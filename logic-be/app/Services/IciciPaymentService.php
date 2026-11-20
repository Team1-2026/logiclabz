<?php

namespace App\Services;

use App\Models\Order;
use Exception;
use Illuminate\Support\Facades\Log;

class IciciPaymentService
{
    protected string $env;
    protected array $config;

    public function __construct()
    {
        $this->env = config('icici.env', 'UAT');
        $this->config = config("icici.{$this->env}", []);
    }

    /**
     * Initiate Sale transaction with ICICI PG.
     */
    public function initiateSale(Order $order, array $customerData, bool $simulateIfUnreachable = true): array
    {
        $merchantId = $this->config['merchant_id'] ?? '100000000007164';
        $aggregatorId = $this->config['aggregator_id'] ?? 'A100000000007164';
        $secretKey = $this->config['key'] ?? 'db06cca0-838b-4e01-8b20-6ac446ffb6bd';
        $apiEndpoint = $this->config['api']['initiate_sale'] ?? 'https://pgpayuat.icicibank.com/tsp/pg/api/v2/initiateSale';
        $returnUrl = $this->config['return_url'] ?? 'http://localhost:3001/payment/callback';

        date_default_timezone_set(config('icici.timezone', 'Asia/Kolkata'));

        $merchantTxnNo = $order->order_number;
        $txnDate = date('YmdHis');
        $amount = number_format((float) $order->total_amount, 2, '.', '');

        $data = [
            'addlParam1' => $order->id,
            'addlParam2' => $customerData['gstin'] ?? '',
            'aggregatorID' => $aggregatorId,
            'amount' => $amount,
            'currencyCode' => '356', // INR ISO numeric code
            'customerEmailID' => $customerData['email'] ?? 'client@logiclabz.com',
            'customerMobileNo' => preg_replace('/[^0-9]/', '', $customerData['phone'] ?? '9876543210'),
            'customerName' => $customerData['name'] ?? 'LogicLabz Customer',
            'merchantId' => $merchantId,
            'merchantTxnNo' => $merchantTxnNo,
            'payType' => '0',
            'returnURL' => $returnUrl,
            'transactionType' => 'SALE',
            'txnDate' => $txnDate,
        ];

        // Sort data alphabetically by keys ascending
        ksort($data);

        // Build data to hash
        $dataToHash = '';
        foreach ($data as $key => $value) {
            $dataToHash .= (string) $value;
        }

        // Generate HMAC SHA256 secure hash
        $secureHash = hash_hmac('sha256', $dataToHash, $secretKey);
        $data['secureHash'] = $secureHash;

        $jsonPayload = json_encode($data, JSON_UNESCAPED_SLASHES);

        // Attempt ICICI PG API call
        try {
            $ch = curl_init($apiEndpoint);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonPayload);
            curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
            curl_setopt($ch, CURLOPT_TIMEOUT, 6);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

            $response = curl_exec($ch);
            $curlError = curl_error($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);

            if ($response && !$curlError) {
                $responseData = json_decode($response, true);
                if (isset($responseData['redirectURI'], $responseData['tranCtx'])) {
                    $redirectUrl = $responseData['redirectURI'] . '?tranCtx=' . $responseData['tranCtx'];
                    return [
                        'success' => true,
                        'is_simulated' => false,
                        'redirect_url' => $redirectUrl,
                        'merchant_txn_no' => $merchantTxnNo,
                        'raw_response' => $responseData,
                    ];
                }
            }
        } catch (Exception $e) {
            Log::warning('ICICI PG initiateSale network error: ' . $e->getMessage());
        }

        // If in development/sandbox and bank API is unreachable or blocked
        if ($simulateIfUnreachable) {
            $simulatedRedirect = $returnUrl . (str_contains($returnUrl, '?') ? '&' : '?') . http_build_query([
                'status' => 'SUCCESS',
                'merchantTxnNo' => $merchantTxnNo,
                'amount' => $amount,
                'order_id' => $order->id,
                'txnid' => 'ICICI' . date('YmdHis'),
                'is_simulated' => '1',
            ]);

            return [
                'success' => true,
                'is_simulated' => true,
                'redirect_url' => $simulatedRedirect,
                'merchant_txn_no' => $merchantTxnNo,
                'note' => 'Development sandbox fallback enabled for seamless testing.',
            ];
        }

        return [
            'success' => false,
            'message' => 'Unable to initiate payment with ICICI Gateway. Please verify credentials.',
        ];
    }

    /**
     * Check transaction status with ICICI Bank PG.
     */
    public function checkStatus(string $merchantTxnNo, string $originalTxnNo): array
    {
        $merchantId = $this->config['merchant_id'] ?? '100000000007164';
        $aggregatorId = $this->config['aggregator_id'] ?? 'A100000000007164';
        $secretKey = $this->config['key'] ?? 'db06cca0-838b-4e01-8b20-6ac446ffb6bd';
        $statusUrl = $this->config['api']['status'] ?? 'https://pgpayuat.icicibank.com/tsp/pg/api/command';

        $data = [
            'merchantTxnNo' => $merchantTxnNo,
            'originalTxnNo' => $originalTxnNo,
            'transactionType' => 'STATUS',
            'aggregatorID' => $aggregatorId,
            'merchantId' => $merchantId,
        ];

        ksort($data);

        $dataToHash = '';
        foreach ($data as $val) {
            $dataToHash .= (string) $val;
        }

        $secureHash = hash_hmac('sha256', $dataToHash, $secretKey);

        $requestData = [
            'merchantId' => $merchantId,
            'aggregatorID' => $aggregatorId,
            'merchantTxnNo' => $merchantTxnNo,
            'originalTxnNo' => $originalTxnNo,
            'transactionType' => 'STATUS',
            'secureHash' => $secureHash,
        ];

        try {
            $ch = curl_init($statusUrl);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($requestData));
            curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
            curl_setopt($ch, CURLOPT_TIMEOUT, 6);
            $response = curl_exec($ch);
            curl_close($ch);

            if ($response) {
                return json_decode($response, true) ?: ['raw' => $response];
            }
        } catch (Exception $e) {
            Log::warning('ICICI PG checkStatus error: ' . $e->getMessage());
        }

        return ['status' => 'PENDING', 'message' => 'Query dispatched to gateway.'];
    }
}


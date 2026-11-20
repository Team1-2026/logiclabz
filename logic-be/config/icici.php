<?php

return [
    'env' => env('ICICI_ENV', 'UAT'), // 'UAT' or 'LIVE'

    'UAT' => [
        'merchant_id'   => env('ICICI_UAT_MERCHANT_ID', '100000000007164'),
        'aggregator_id' => env('ICICI_UAT_AGGREGATOR_ID', 'A100000000007164'),
        'key'           => env('ICICI_UAT_SECRET_KEY', 'db06cca0-838b-4e01-8b20-6ac446ffb6bd'),
        'api' => [
            'initiate_sale' => 'https://pgpayuat.icicibank.com/tsp/pg/api/v2/initiateSale',
            'status'        => 'https://pgpayuat.icicibank.com/tsp/pg/api/command',
            'refund'        => 'https://pgpayuat.icicibank.com/tsp/pg/api/command',
        ],
        'return_url'    => env('ICICI_RETURN_URL', 'http://localhost:3001/payment/callback'),
    ],

    'LIVE' => [
        'merchant_id'   => env('ICICI_LIVE_MERCHANT_ID', 'YourLiveMerchantId'),
        'aggregator_id' => env('ICICI_LIVE_AGGREGATOR_ID', 'YourLiveAggregatorId'),
        'key'           => env('ICICI_LIVE_SECRET_KEY', 'YourLiveSecretKey'),
        'api' => [
            'initiate_sale' => 'https://pgpay.icicibank.com/pg/api/v2/initiateSale',
            'status'        => 'https://pgpay.icicibank.com/pg/api/command',
            'refund'        => 'https://pgpay.icicibank.com/pg/api/command',
        ],
        'return_url'    => env('ICICI_RETURN_URL', 'https://portal.logiclabz.com/payment/callback'),
    ],

    'timezone' => 'Asia/Kolkata',
];


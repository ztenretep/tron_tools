#!/usr/bin/perl -w

use Inline Python => <<'END_OF_PYTHON_CODE';

import json
from tronapi import Tron

def claim_rewards():
    public_key = '<public_key>'
    private_key = '<private_key>'
    tron = Tron()
    tron.private_key = private_key
    withdraw_tx = tron.transaction_builder.withdraw_block_rewards(public_key)
    withdraw_tx = tron.trx.sign_and_broadcast(withdraw_tx)
    withdraw = json.dumps(withdraw_tx, indent=2)
    print(withdraw)

END_OF_PYTHON_CODE

claim_rewards();

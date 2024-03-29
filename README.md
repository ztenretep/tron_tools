# Tools for the TRON Blockchain

## Motivation

<p align="justify">In the past I used a wallet that allowed me to do TRON (TRX) staking. Some times ago, that wallet provider disabled the staking function. Accordingly, I was looking for a way to do everything necessary from the command line on myself. With the tronapi from PyPi I found a Python package that seems to be useful for testing purposes and more.</p>

## Introduction

<p align="justify">In order to understand how access to the TRON blockchain is possible, I wrote scripts in BASH and Python so far. Unlike in other cryptocurrencies, the operation of a local TRON node is not necessary. This is a great advantage if you want to interact with the TRON blockchain. 
</p>

<p align="justify">TRON is a fork of the crypto currency Ethereum. As a result of this, programming methods, which were developed for Ethereum are used by TRON in variations. This is important for understanding how to program methods for TRON.</p>

## State of the Art

<p align="justify">Python scripts based on the last <code>tronapi</code> version works well. Using the Python module <code>requests</code> from PyPi, direct access to the TRON RPC API is possible. This allows to use every command from the TRON RPC API.</p>

## TRON (TRX) Staking

<p align="justify">Tron (TRX) staking works as follows. First step is to freeze an amount of Tron. Next one has to identify an so called 
Super Representative (SR). Afterwards one votes for this SR. That's it in principle. Rewards can be claimed on a daily basis.</p>

## Implemented Methods

<p align="justify">It is implemented so far:</p>

- <p align="justify">Creating TRON accounts.</p>
- <p align="justify">Requesting account informations from the TRON blockchain.</>
- <p align="justify">Freezing TRON balance for staking.</>
- <p align="justify">Unfreezing TRON balance from staking.</>
- <p align="justify">Voting for TRON Super Representatives.</>
- <p align="justify">Claiming rewards from the TRON blockchain.</>
- <p align="justify">and some more ...</>

## Organisation of the Scripts

<p align="justify">I am gradually organising the scripts under main-categories like BASH and Python for the used programming languages, and sub-categories like account creation and staking for the methods etc.</p>

<h2>Donation</h2>

<div class="snippet-clipboard-content position-relative overflow-auto" data-snippet-clipboard-copy-content="TQamF8Q3z63sVFWiXgn2pzpWyhkQJhRtW7"><pre><code>TQamF8Q3z63sVFWiXgn2pzpWyhkQJhRtW7</code></pre></div>

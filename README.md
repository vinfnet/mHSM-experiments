# mHSM-experiments
Experiments in using Azure Managed HSM

A simple script to encrypt and decrypt a string using a key held in an Azure Managed HSM - data is sent to the HSM, encrypted and returned to the client
Based on examples here https://learn.microsoft.com/en-us/powershell/module/az.keyvault/invoke-azkeyvaultkeyoperation?view=azps-13.2.0

Usage: .\encrypt-and-decrypt-string.ps1 -hsmName "<NAME OF YOUR MANAGED HSM>" -keyName "<NAME OF YOUR KEY>" [Optional] -plainText "<STRING TO ENCRYPT>"

Example: .\encrypt-and-decrypt-string.ps1 -hsmName "myHSM" -keyName "myKey" -plainText "string to encrypt"

Note: you will need to have the Azure PowerShell module installed and be logged in to your Azure account

Your user account will need 'Managed HSM Crypto User' permissions on the Managed HSM to do this.
Note: Administrator role on the HSM does not give you the ability to perform crypto actions - just to manage the HSM itself 
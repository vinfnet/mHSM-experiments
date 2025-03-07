# Simon Gallagher, Azure Confidential Computing, NO WARRANTY, USE AT YOUR OWN RISK
# simple script to encrypt and decrypt a string using a key held in an Azure Managed HSM - the string data is sent to the HSM, encrypted and returned to the client
# based on examples here https://learn.microsoft.com/en-us/powershell/module/az.keyvault/invoke-azkeyvaultkeyoperation?view=azps-13.2.0
# Usage: .\encrypt-and-decrypt-string.ps1 -hsmName "<NAME OF YOUR MANAGED HSM>" -keyName "<NAME OF YOUR KEY>" [Optional] -plainText "<STRING TO ENCRYPT>"
# Example: .\encrypt-and-decrypt-string.ps1 -hsmName "myHSM" -keyName "myKey"
# Note: you will need to have the Azure PowerShell module installed and be logged in to your Azure account

param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$hsmName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$keyName,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$plainText
    )

# Prompt the user for a string to encrypt if they didn't pass it at the command line
if (-not $PSCmdlet.MyInvocation.BoundParameters.ContainsKey('plainText')) {
    $plainText = Read-Host "Please enter the string you want to encrypt and decrypt"
}

# Action when all if and elseif conditions are false #>
# encrypt a string using mHSM held key
$byteArray = [system.Text.Encoding]::UTF8.GetBytes($plainText)
$encryptedData = Invoke-AzKeyVaultKeyOperation -Operation Encrypt -Algorithm RSA1_5 -HsmName $hsmName -Name $keyName -ByteArrayValue $byteArray
write-host "[" $plainText "] has been encrypted using key [" $keyname "] and is now `n " $encryptedData.RawResult -ForegroundColor Blue

# to be sure we aren't cheating, reset the string
$plainText = "if you can read this, something has gone wrong!"

# now decrypt a string using mHSM held key
$decryptedData = Invoke-AzKeyVaultKeyOperation -Operation Decrypt -Algorithm RSA1_5 -HsmName $hsmName -Name $keyName -ByteArrayValue $encryptedData.RawResult
$plainText = [system.Text.Encoding]::UTF8.GetString($decryptedData.RawResult)
write-host "This has been decrypted as: " $plainText -ForegroundColor Green


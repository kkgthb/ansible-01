az ssh vm `
    --subscription "$([Environment]::GetEnvironmentVariable('DEMOS_my_azure_subscription_id', 'User'))" `
    --resource-group "$([Environment]::GetEnvironmentVariable('DEMOS_my_workload_nickname', 'User'))-rg-demo" `
    --vm-name "$("$([Environment]::GetEnvironmentVariable('DEMOS_my_workload_nickname', 'User'))")Vm"

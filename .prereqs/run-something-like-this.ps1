# # Terraformize my usual demo environment variables
# [Environment]::SetEnvironmentVariable( `
#         'TF_VAR_entra_tenant_id', `
#         [Environment]::GetEnvironmentVariable('DEMOS_my_entra_tenant_id', 'User'), `
#         'User' `
# )
# [Environment]::SetEnvironmentVariable( `
#         'TF_VAR_az_sub_id', `
#         [Environment]::GetEnvironmentVariable('DEMOS_my_azure_subscription_id', 'User'), `
#         'User' `
# )
# [Environment]::SetEnvironmentVariable( `
#         'TF_VAR_workload_nickname', `
#         [Environment]::GetEnvironmentVariable('DEMOS_my_workload_nickname', 'User'), `
#         'User' `
# )


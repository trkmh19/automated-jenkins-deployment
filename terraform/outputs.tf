output "public_ip_address" {
  description = "the public IP address of the Jenkins VM"
  value       = azurerm_public_ip.this.ip_address
}
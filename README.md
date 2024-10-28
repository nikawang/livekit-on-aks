## livekit-on-aks
Deploy [livekit server & livekit playground & livekit agent](https://playground.livekit.io/), on Azure with terraform.

### Kick Start
```bash
terraform init
terraform plan
terraform apply --auto-approve
```

### Tips
1. You may need to modify the DNS&IP setting in your DNS provider service for the Ingress host and LoadBanacer IP.
2. You may need to add nsg rule for inbound traffic like 50000-60000,80,443,7880,7881 to subnet nsg, in case your company has strict network policy.
3. Type the OPEN AI KEY of GPT-4o Realtime model created by the terroform to the text box in the playground page.
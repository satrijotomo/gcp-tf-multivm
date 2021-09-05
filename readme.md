**What these TF scripts do**
1. Create multiple static PIPs
2. Create multiple VM instances and attach each static PIP to the VM instance
3. Also upload public key metadata for defined user in each VM instance
4. SSH to each instance and running remote-exec

**Expected Result**
After script is finished running, go to Compute Engine page in Google Cloud Console and get the public IP address of each VM.
Open http sessions from a browser toward the public IP addresses. You should see a message from each VM: 
"CONGRATS!!..You have configured successfully your remote exec provisioner!"

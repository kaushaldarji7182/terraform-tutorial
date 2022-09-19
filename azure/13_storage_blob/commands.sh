Azure Storage 
-------------
	Blob storage 
		storage tiers
	File storage
	Table storage
	Queue storage
	Disk storage
	
Data
	structured
		e.g. relational data
	unstructured
		workspace
	semi-structured
		tables
			row doesnt need to follow schemas.
			each row can have it's on rules
			
	
Azure Blob Storage
	Designed for storage of files of any kind
	(BLOB - Binary large objects - files)
	Three storage tiers (storage tiers: allows azure to offer best price for different storage types)
		Hot - frequently accessed data
		Cool - infrequently accessed data
		Archive  - rarely accessed data
	
Azure Table Storage
	Semi-structured storage
	NoSQL 
	No joins or relationships
	Peta bites of data read in milli seconds.

Azure File Storage
	Similar to Azure Blob Storage
	
	Azure File Storage 				Azure Blob Storage
	Files							Blobs
	Shares								containers
	
	So identical but differs on how you accessed
	In windows we can map drive to Azure File Storage
	
Azure Storage Account
	Collection of services above
		Blob storage
		Queue storage
		Table storage
		File storage
		
	Used to store 
		files
		messages (Azure Queue not mentioned above)
		semi-structured dtaa 
	








# make sure terraform CLI is installed
terraform

# format the tf files
terraform fmt

# initialize terraform Azure modules
terraform init

# validate the template
terraform validate

# plan and save the infra changes into tfplan file
terraform plan -out tfplan

# show the tfplan file
terraform show -json tfplan
terraform show -json tfplan >> tfplan.json

# Format tfplan.json file
terraform show -json tfplan | jq '.' > tfplan.json

# show only the changes
cat tfplan.json | jq -r '(.resource_changes[] | [.change.actions[], .type, .change.after.name]) | @tsv'
cat tfplan.json | jq '[.resource_changes[] | {type: .type, name: .change.after.name, actions: .change.actions[]}]' 

# apply the infra changes
terraform apply tfplan

# delete the infra
terraform destroy

# cleanup files
rm terraform.tfstate
rm terraform.tfstate.backup
rm tfplan
rm tfplan.json
rm -r .terraform/
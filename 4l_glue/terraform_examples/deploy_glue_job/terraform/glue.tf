resource "aws_s3_object" "test_deploy_script_s3" {
  bucket 	= var.s3_bucket
  key 		= "glue/scripts/TestDeployScript.py"
  source 	= "${local.glue_src_path}TestDeployScript.py"
  etag 		= filemd5("${local.glue_src_path}TestDeployScript.py")
#		MD5 hash of the local script file. 
#		It helps ensure Terraform only uploads the script if it has changed.

}

resource "aws_glue_job" "test_deploy_script" {
  glue_version 	= "4.0" #optional
  max_retries 	= 0 #optional
  name 			= "TestDeployScript" #required
  description 	= "test the deployment of an aws glue job to aws glue service with terraform" #description
  role_arn 		= aws_iam_role.glue_service_role.arn #required
  number_of_workers = 2 #optional, defaults to 5 if not set
  worker_type 	= "G.1X" #optional
  timeout 		= "60" #optional
  execution_class = "FLEX" #optional
  tags = {
    project = var.project #optional
  }
  command {
    name="glueetl" #optional
    script_location = "s3://${var.s3_bucket}/glue/scripts/TestDeployScript.py" #required
  }
  default_arguments = {
    "--class"                   = "GlueApp"
    "--enable-job-insights"     = "true"
    "--enable-auto-scaling"     = "false"
    "--enable-glue-datacatalog" = "true"
    "--job-language"            = "python"
    "--job-bookmark-option"     = "job-bookmark-disable"
    "--datalake-formats"        = "iceberg"
    "--conf"                    = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions  --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog  --conf spark.sql.catalog.glue_catalog.warehouse=s3://tnt-erp-sql/ --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog  --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO"

  }
}


/*
-----------------------
This code defines two resources in Terraform that work together to deploy a Glue job to AWS Glue service:

1. aws_s3_object (resource named test_deploy_script_s3):

	Uploads a Python script named TestDeployScript.py to a specific location in an S3 bucket.

	bucket: This argument references a variable named s3_bucket defined elsewhere in your Terraform configuration. This variable likely holds the name of the S3 bucket you want to store the script in.
	key: 
		path within the S3 bucket 
			where the script will be stored. 
			In this case, it's glue/scripts/TestDeployScript.py.
	source: 
		location of the script file on your local machine. 
		The local path is defined in a local variable named glue_src_path.
	etag: 
		MD5 hash of the local script file. 
		It helps ensure Terraform only uploads the script if it has changed.
2. aws_glue_job (resource named test_deploy_script):

Defines a Glue job named "TestDeployScript".
	glue_version: 
		optional argument 
			Glue version to use. 
		In this case, it's set to "4.0" but can be omitted.
	name: 
		This is a required argument that defines the name of the Glue job.
	description: 
		Provides a human-readable description for the job.
	role_arn: 
		required argument 
		references the IAM role 
			that the Glue job will use to 
				access AWS resources. 
		It's set to the ARN of a role named glue_service_role 
			defined elsewhere in your Terraform code.
	number_of_workers: 
		An optional argument 
			specifying the number of worker nodes 
				used by the Glue job. 
		Here it's set to 2
			defaults to 5 if not configured.
	worker_type: 
		Defines the type of worker nodes used by the job. 
		Here it's set to "G.1X". 
			Refer to AWS documentation for available worker types.
	timeout: 
		Sets the maximum amount of time (in minutes) the 
			job can run before 
				being terminated. 
		It's set to 60 minutes here.
	execution_class: 
		Defines the execution class for the job (optional). Here it's set to "FLEX" but can be omitted.
	tags: 
		An optional block to add tags to the Glue job for easier organization and management. Here, it adds a tag named "project" with the value coming from the var.project variable.
	command: 
		This is a required block that defines the script and arguments the Glue job will execute.
	name: 
		optional argument 
			name for the command within the job. 
			Here it's set to "glueetl" but can be omitted.
	script_location: 
		required argument 
			location of the script in S3. 
		It uses string interpolation 
			to reference the S3 bucket name 
				from the var.s3_bucket variable and the 
				path defined in the aws_s3_object resource.
	default_arguments: 
		This block defines additional arguments passed to the script when executed by the Glue job.
	In summary, this code uploads a Python script to S3 and then defines a Glue job that references that script location. The Glue job utilizes an IAM role and various configurations for running the script on worker nodes within the AWS Glue service.



*/





<?php
namespace App\Console\Commands;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;
use Aws\S3\S3Client;
use League\Flysystem\AwsS3V3\AwsS3V3Adapter;

class CreateS3Bucket extends Command
{
    protected $signature = 's3:create-bucket';
    protected $description = 'Create the S3 bucket if it does not exist';

    public function handle()
    {
        $bucket = env('AWS_BUCKET');
        $this->info("Checking for bucket: $bucket");

        // Get the underlying S3 client from the adapter
        $adapter = Storage::disk('s3')->getAdapter();

        if (!$adapter instanceof AwsS3V3Adapter) {
            $this->error('S3 disk is not using AwsS3V3Adapter');
            return 1;
        }

        $s3 = $adapter->getClient();

        try {
            $s3->headBucket(['Bucket' => $bucket]);
            $this->info("✅ Bucket '$bucket' already exists.");
        } catch (\Aws\S3\Exception\S3Exception $e) {
            if ($e->getAwsErrorCode() === 'NotFound') {
                $this->info("Bucket not found. Creating bucket '$bucket'...");
                $s3->createBucket(['Bucket' => $bucket]);
                $this->info("✅ Bucket '$bucket' created successfully.");
            } else {
                $this->error("❌ Error checking/creating bucket: " . $e->getMessage());
                return 1;
            }
        }

        return 0;
    }
}
?>

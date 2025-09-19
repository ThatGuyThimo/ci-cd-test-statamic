<?php
// docker-entrypoint-create-user.php
use Statamic\Facades\User;

require __DIR__ . '/../vendor/autoload.php'; // relative to /docker/

$adminEmail = env('STATAMIC_ADMIN_EMAIL', 'admin@example.com');
$adminPassword = env('STATAMIC_ADMIN_PASSWORD', 'secret');

if (User::all()->isEmpty()) {
    User::make()
        ->email($adminEmail)
        ->password($adminPassword)
        ->firstName('Admin')
        ->lastName('User')
        ->roles(['admin'])
        ->save();

    echo "Created default admin user: {$adminEmail}\n";
} else {
    echo "User(s) already exist, skipping creation.\n";
}

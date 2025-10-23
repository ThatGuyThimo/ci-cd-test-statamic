<?php

namespace App\Providers;

use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use Statamic\Statamic;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {

        $this->configureSecureUrls();

        // Statamic::vite('app', [
        //     'resources/js/cp.js',
        //     'resources/css/cp.css',
        // ]);
    }

    protected function configureSecureUrls()
    {
        // Determine if HTTPS should be enforced
        $enforceHttps = $this->app->environment(['production', 'staging'])
            && !$this->app->runningUnitTests();
 
        // Force HTTPS for all generated URLs
        URL::forceHttps($enforceHttps);
 
        // Ensure proper server variable is set
        if ($enforceHttps) {
            $this->app['request']->server->set('HTTPS', 'on');
        }
 
        // Set up global middleware for security headers
        if ($enforceHttps) {
            $this->app['router']->pushMiddlewareToGroup('web', \App\Http\Middleware\SecurityHeadersMiddleware::class);
        }
    }
}

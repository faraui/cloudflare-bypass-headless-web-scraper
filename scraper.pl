use strict;
use warnings;
use open qw( :std :encoding(UTF-8) );
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
use WWW::Mechanize::Chrome;

my $mech = WWW::Mechanize::Chrome->new(
   host => '127.0.0.1',        # Host on which DevTools listens for commands
   port => 9222,               # Port on which DevTools listens for commands
   start_url => 'about:blank', # Immediately navigate to a given address
   autoclose => 0,             # Do not close browser at the end of execution
   separate_session => 1,      # Create a new session without cookies
   startup_timeout => 10,      # Time waiting for a browser to launch
   autodie => 0,               # Treat HTTP errors as non-fatal
   headless => 0,              # Disable browser built-in headless mode
   mute_audio => 1,            # Disable audio channel
   cleanup_signal => 'TERM',   # The signal that is sent to the browser to stop it
);

print STDERR "Web-scraper execution ...";

$mech->get('https://www.cloudflare.com/');
$mech->sleep( 8 );

my $page_pdf = $mech->content_as_pdf(
   filename => 'cloudflare.pdf',
);

print STDERR " OK\n";

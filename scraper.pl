use strict;
use warnings;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
use WWW::Mechanize::Chrome;

my $mech = WWW::Mechanize::Chrome->new(
  autodie => 0,               # Treat HTTP errors as non-fatal
  headless => 0,              # Disable Chrome built-in headless mode
  host => '127.0.0.1',        # Host on which DevTools listens for commands
  port => 9222,               # Port on which DevTools listens for commands
  cleanup_signal => 'TERM',   # The signal that is sent to the browser to stop it
  start_url => 'about:blank', # Immediately navigate to a given address
  autoclose => 0,             # Do not close browser at the end of execution
  separate_session => 1,      # Create a new session without cookies
  startup_timeout => 10,      # Time waiting for a browser to launch
  mute_audio => 0,            # Disable audio channel
);

print "Web-scraper execution ...";

$mech->get('https://www.cloudflare.com/');
$mech->sleep( 6 );

my $page_pdf = $mech->content_as_pdf(
    filename => 'cloudflare.pdf',
);

print " OK\n";

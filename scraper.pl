use strict;
use warnings;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
use WWW::Mechanize::Chrome;

my $mech = WWW::Mechanize::Chrome->new(
  autodie => 0,               # Treat HTTP errors as non-fatal
  headless => 0,              # Disable Chrome built-in headless mode
  host => '127.0.0.1',        # Host on which Chrome DevTools listens for commands
  port => 9222,               # Port on which Chrome DevTools listens for commands
  cleanup_signal => 'TERM',   # The signal that is sent to Chrome to shut it down
  start_url => 'about:blank', # Immediately navigate to a given address
  autoclose => 0,             # Do not close Chrome at the end of execution
  separate_session => 1,      # Create a new session without cookies
  startup_timeout => 10,      # Time waiting for the Chrome launch
  mute_audio => 0,            # Disable audio channel
);

$mech->get('https://www.cloudflare.com/');
#$mech->sleep( 10 );

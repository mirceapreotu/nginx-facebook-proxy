package facebook;
 
use nginx; 
use strict;
use CGI;
use MIME::Base64;
use JSON;
use Digest::SHA qw(hmac_sha256);

use constant FACEBOOK_APP_SECRET => 'FACEBOOK_APP_SECRET';

sub parse_signed_request {
  my $request             = shift;
  my $signed_request      = $request->variable('request_body');
  undef $request;
  
  # Extract parameter value
  $signed_request =~ s/\Qsigned_request=\E//g;
  if ($signed_request eq '') {
    return '';
  }

  # Extract signature and payload
  my ($encoded_signature, $payload) = split('\.', $signed_request);
  undef $signed_request;
  
  # Validation
  $encoded_signature    = decode_base64url($encoded_signature);
  my $verify_signature = hmac_sha256($payload, FACEBOOK_APP_SECRET);
  unless ($encoded_signature eq $verify_signature) {    
    return 400; # HTTP 400 Bad Request
  }
  undef $encoded_signature, $verify_signature;
  
  # Decode content
  my $facebook_data = decode_json(decode_base64url($payload));

  # Build request body
  my @fields = ();

  # Facebook Page information
  if (exists $facebook_data->{'page'}) {
    push(@fields, 'facebook[page][id]='       . $facebook_data->{'page'}->{'id'});
    push(@fields, 'facebook[page][liked]='    . (!!$facebook_data->{'page'}->{'liked'} ? 'true' : 'false'));
    push(@fields, 'facebook[page][is_admin]=' . (!!$facebook_data->{'page'}->{'admin'} ? 'true' : 'false'));  
  }

  # Facebook User information (only cachable items)
  if (exists $facebook_data->{'user'}) {
    push(@fields, 'facebook[user][locale]='   . $facebook_data->{'user'}->{'locale'});
  }

  # Facebook app data parameters
  if (exists $facebook_data->{'app_data'}) {
    push(@fields, 'facebook[app_data]=' . encode_json($facebook_data->{'app_data'}));
  }

  undef $facebook_data;
  
  return join "&", @fields;
}

sub decode_base64url {
  my $s = shift;
  $s =~ tr[-_][+/];
  $s .= '=' while length($s) % 4;
  return decode_base64($s);
}
 
1;
__END__
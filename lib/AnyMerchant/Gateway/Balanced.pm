package AnyMerchant::Gateway::Balanced;
use Moo;
with 'AnyMerchant::Gateway';

use Business::BalancedPayments;

has '+base_url' => ( default => sub { 'https://api.balancedpayments.com' } );

has api_keys_uri     => (is => 'ro', default => sub { '/v1/api_keys'     });
has merchants_uri    => (is => 'ro', default => sub { '/v1/merchants'    });
has marketplaces_uri => (is => 'ro', default => sub { '/v1/marketplaces' });

has marketplace => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->get($self->marketplaces_uri)->{items}[0];
    },
);


sub authorize {
    my ($self) = @_;
}

sub capture {
    my ($self, $hold_uri, %params) = @_;
    my $data = { hold_uri => $hold_uri, %params };
    return $self->post($self->marketplace->{debits_uri}, $data);
}

sub charge {
}

sub credit {
}

sub void {
}

# ABSTRACT: Balanced Payments AnyMerchant gateway

=head1 SYNOPSIS

    my $gateway = AnyMerchant->gateway('Balanced', password => 'abc123');

=cut

1;

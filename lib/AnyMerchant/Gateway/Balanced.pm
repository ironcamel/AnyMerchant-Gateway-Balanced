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
    my ($self, %params) = @_;
    my $amount = $params{amount};
    my $card   = $params{source};

    my $hold = {
        amount     => $amount,
        source_uri => $card->{uri},
    };
    my $holds_uri = $card->{account}{holds_uri};
    return $self->post($holds_uri, $hold);
}

sub capture {
    my ($self, %params) = @_;
    my $amount        = $params{amount};
    my $authorization = $params{authorization};

    my $data = { hold_uri => $authorization };
    $data->{amount} = $amount if $amount;
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

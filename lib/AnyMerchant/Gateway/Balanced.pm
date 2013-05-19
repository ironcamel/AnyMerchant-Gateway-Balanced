package AnyMerchant::Gateway::Balanced;
use Moo;
with 'AnyMerchant::Gateway';

sub authorize {
}

sub capture {
}

sub charge {
}

sub refund {
}

sub void {
}

# ABSTRACT: Balanced Payments AnyMerchant gateway

=head1 SYNOPSIS

    my $gateway = AnyMerchant->gateway('Balanced', password => 'abc123');

=cut

1;

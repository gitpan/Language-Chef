
package Language::Chef::Container;

use strict;
use warnings;

use Carp;

use Language::Chef::Ingredient;

use vars qw/$VERSION/;
$VERSION = '0.04';

sub new {
   my $proto = shift;
   my $class = ref $proto || $proto;

   my $self = {};

   if (ref $proto) {
      %$self = %$proto;
      $self->{contents} = [ map { $_->new() } @{$self -> {contents}} ];
   }

   %$self = (
     contents => [],
     %$self,
     @_,
   );

   return bless $self => $class;
}


sub put {
   my $self = shift;

   my @ingredients = @_;

   push @{$self->{contents}}, $_->new() for @ingredients;

   return $self;
}


sub fold {
   my $self = shift;

   my $ingredient = shift;

   croak "Invalid operation on empty container: fold."
     unless @{$self->{contents}};

   my $new_val = pop @{ $self->{contents} };

   $ingredient->value( $new_val->value() );

   return $ingredient;
}


sub add {
   my $self = shift;

   my $ingredient = shift;

   croak "Invalid operation on empty container: add."
     unless @{$self->{contents}};

   $self->{contents}->[-1]->value(
     $self->{contents}->[-1]->value() +
     $ingredient->value()
   );

   return $ingredient;
}


sub remove {
   my $self = shift;

   my $ingredient = shift;

   croak "Invalid operation on empty container: remove."
     unless @{$self->{contents}};

   $self->{contents}->[-1]->value(
     $self->{contents}->[-1]->value() -
     $ingredient->value()
   );

   return $ingredient;
}


sub combine {
   my $self = shift;

   my $ingredient = shift;

   croak "Invalid operation on empty container: combine."
     unless @{$self->{contents}};

   $self->{contents}->[-1]->value(
     $self->{contents}->[-1]->value() *
     $ingredient->value()
   );

   return $ingredient;
}


sub divide {
   my $self = shift;

   my $ingredient = shift;

   croak "Invalid operation on empty container: divide."
     unless @{$self->{contents}};

   $self->{contents}->[-1]->value(
     $self->{contents}->[-1]->value() /
     $ingredient->value()
   );

   return $ingredient;
}


sub put_sum {
   my $self = shift;

   my @ingredients = @_;

   my $sum = 0;
   $sum += $_->value() for @ingredients;

   my $ingredient = Language::Chef::Ingredients->new(
     name    => '',
     value   => $sum,
     measure => '',
     type    => 'dry',
   );

   $self->put($ingredient);

   return $ingredient;
}


sub liquify_contents {
   my $self = shift;

   foreach my $ingredient (@{$self->{contents}}) {
      $ingredient->liquify();
   }

   return $self;
}


sub stir_time {
   my $self = shift;

   my $depth = shift;

   return $self unless scalar @{$self->{contents}};

   $depth = $#{$self->{contents}} if $depth > $#{$self->{contents}};

   my $top = pop @{ $self->{contents} };
   splice @{$self->{contents}}, (@{$self->{contents}}-$depth), 0, $top;

   return $self;
}


sub stir_ingredient {
   my $self = shift;

   my $ingredient = shift;

   $self->stir_time($ingredient->value());

   return $self;
}


sub mix {
   my $self = shift;

   _fisher_yates_shuffle( $self->{contents} );

   return $self;
}


sub clean {
   my $self = shift;

   @{$self->{contents}} = ();

   return $self;
}


sub pour {
   my $self = shift;

   return @{ $self->{contents} };
}


sub print {
   my $self = shift;

   my $string = '';

   foreach my $ingr ( reverse @{$self->{contents}} ) {
      if ($ingr->type() eq 'liquid') {
         $string .= chr( $ingr->value() );
      } else {
         $string .= ' '.$ingr->value();
      }
   }

   return $string;
}


# From the Perl FAQ: (NOT a method)
# fisher_yates_shuffle( \@array ) :
# generate a random permutation of @array in place
sub _fisher_yates_shuffle {
    my $array = shift;
    my $i;
    for ($i = @$array; --$i; ) {
        my $j = int rand ($i+1);
        @$array[$i,$j] = @$array[$j,$i];
    }
}

__END__

=pod

=head1 NAME

Language::Chef::Container - Internal module used by Language::Chef

=head1 SYNOPSIS

  use Language::Chef;

=head1 DESCRIPTION

Please see L<Language::Chef>;

=head1 AUTHOR

Steffen Mueller.

Chef designed by David Morgan-Mar.

=head1 COPYRIGHT

Copyright (c) 2002-2003 Steffen Mueller. All rights reserved. This program is
free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

Author can be reached at chef-module at steffen-mueller dot net

=cut



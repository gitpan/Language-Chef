
package Language::Chef::Ingredient;

use strict;
use warnings;

use Carp;

use vars qw/$VERSION %Measures %MeasureTypes/;
$VERSION = '0.03';

%Measures = (
  ''          => '',

  g           => 'dry',
  kg          => 'dry',
  pinch       => 'dry',
  pinches     => 'dry',
  ml          => 'liquid',
  l           => 'liquid',
  dash        => 'liquid',
  dashes      => 'liquid',
  cup         => '',
  cups        => '',
  teaspoon    => '',
  teaspoons   => '',
  tablespoon  => '',
  tablespoons => '',
);

%MeasureTypes = (
  heaped => 'dry',
  level  => 'dry',
);

sub new {
   my $proto = shift;
   my $class = ref $proto || $proto;

   my $self = {};

   if ( ref $proto ) {
      %$self = %$proto;
   }

   my %args  = @_;

   %$self = (
     name         => '',
     value        => undef,
     measure      => '',
     measure_type => '',
     type         => '',
     %$self,
     %args,
   );

   bless $self => $class;

   $self->determine_type() if not $self->{type};

   return $self;
}


sub type {
   my $self = shift;

   $self->determine_type() if $self->{type} eq '';

   return $self->{type};
}


sub determine_type {
   my $self = shift;

   my $type = '';

   exists $Measures{$self->{measure}}
     or croak "Invalid measure specified: '$self->{measure}'.";

   $type = $Measures{ $self->{measure} };

   if ( exists $MeasureTypes{ $self->{measure_type} } ) {

      if ( $type eq '' ) {
         $type = $MeasureTypes{ $self->{measure_type} };
      } else {
         $MeasureTypes{ $self->{measure_type} } eq $type
           or croak "'Measure type' ($self->{measure_type}) does not match type of measure ($type).";
      }

   }

   $self->{type} = $type;
   return $self->{type};
}


sub value {
   my $self = shift;
   my $new_val = shift;

   $self->{value} = $new_val if defined $new_val;

   if (not defined $self->{value}) {
      my $name = $self->{name};
      croak "Attempted to use undefined ingredient '$name'.";
   }

   return $self->{value};
}


sub liquify {
   my $self = shift;

   $self->{type} = 'liquid';

   return $self;
}

__END__

=pod

=head1 NAME

Language::Chef::Ingredient - Internal module used by Language::Chef

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

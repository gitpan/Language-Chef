use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Language::Chef',
    'VERSION_FROM'	=> 'lib/Language/Chef.pm', # finds $VERSION
    'EXE_FILES'         => ['chef.pl', 'compilechef.pl'],
    'PREREQ_PM'		=> {Test::More => 0.44, File::Temp => 0.12}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Language/Chef.pm', # retrieve abstract from module
       AUTHOR     => 'Steffen Mueller <chef-module@steffen-mueller.net>') : ()),
);


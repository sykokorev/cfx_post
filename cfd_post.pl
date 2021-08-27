
> turbo init
> turbo more_vars
#!/usr/bin/perl
! use Cwd;

# Declare variables
! my $dir = getcwd;
! my @files;
! my %inlet_list;
! my %outlet_list;
! my %init_rows;
! my @rows;

! # Output data files
! my $int_file = "$dir" . "/" . "integral_parameters.csv";

! # Get .res files
! opendir(DIR, $dir) or die "can't opendir $dir: $!";
! @files = grep { /\.(res)$/ } readdir DIR;

! foreach my $file (@files)
! {
!
!   # Get case name
!   my $current_case_name = getValue("DATA READER", "Current Case List");
!
!   # Get domain list
!   my $domains = getChildren($current_case_name, "DOMAIN");
!   $domains =~ s/DOMAIN://g;
!   my @rows = split(/,/, $domains);
!
!   # Get current component number
!   foreach my $row (@rows)
!  {
!     my $current_component_number = getValue($row, "Components to Initialize");
!     $current_component_number =~ s/Component //g;
!     $init_rows{$current_component_number} = $row;
!   }
!
!   # Get inlet and outlet regions of each domains
!    while ((my $num, my $dmn) = each(%init_rows))
!   {
!     my $inlet = getValue($dmn, "Inlet Region");
!     my @inlet = split(/,/, $inlet);
!     $inlet_list{$dmn} = [@inlet];
!     my $outlet = getValue($dmn, "Outlet Region");
!     my @outlet = split(/,/, $outlet);
!     $outlet_list{$dmn} = [@outlet];
!   }
!   open ($int, '>', $int_file);
!   foreach my $num (sort keys (%init_rows))
!   {
!      $dmn = $init_rows{$num};
!       my $ptotw_in;
!       my  $ptotw_out;
!       my $ptot_in;
!       my $ptot_out;
!       my ($ttotw_in, $ttotw_out, $ttot_in, $ttot_out) = (0)*4;
!       foreach $in (@{$inlet_list{$dmn}})
!       {
!          $ptotw_in = massFlowAve("Total Pressure in Rel Frame", "$in");
!          $ptot_in = massFlowAve("Total Pressure in Stn Frame", "$in");
!          $ttotw_in = massFlowAve("Total Temperature in Rel Frame", "$in");
!          $ttot_in = massFlowAve("Total Temperature in Stn Frame", "$in");
!        }
!        foreach $out (@{$outlet_list{$dmn}})
!       {
!          $ptotw_out = massFlowAve("Total Pressure in Rel Frame", "$out");
!          $ptot_out = massFlowAve("Total Pressure in Stn Frame", "$out");
!          print "$out - $ptot_out \n";
!          $ttotw_out = massFlowAve("Total Temperature in Rel Frame", "$out");
!          $ttot_out = massFlowAve("Total Temperature in Stn Frame", "$out");
!        }
!     my $pr = $ptot_out / $ptot_in;
!     print "$dmn PR = $pr \n";
!   }
!   close $int;
! }

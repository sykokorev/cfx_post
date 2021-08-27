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
!
!   my $in = $init_rows{1};
!   my $out = $init_rows{%init_rows};
!   print "$in -> $out\n";
!
! }

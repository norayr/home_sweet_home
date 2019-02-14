## Copyright 2009-2010 Thomas Fischer <fischer@unix-ag.uni-kl.de>

##  This Perl script is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.

use Math::Trig;
use Image::Magick;
use LWP::UserAgent;
use Getopt::Long qw(:config no_ignore_case);
use strict;
use warnings;

## output filename, can be set with  -o FILENAME
my $outputfilename = "map.png";

## zoom level of map, can be set with  -z N
## where N is 1..16 or "auto"
my $zoom = "auto";
my $useautozoom = $zoom eq "auto";

## create animation steps by saving individual images
## for each drawn track, can be set with  -A
my $doanimate = undef;

## sparse map flag (draw only tiles touched by tracks)
## can be set with  -s
my $sparse = 0;

## quiet flag, can be set with  -q
my $quiet = 0;

## maximum number of tiles used in autozoom mode
## can be set with  -a N
## setting parameter -a forces autozoom
my $maxnumautotiles = 32;

## additional border tiles
my $additionalborder = 0;

## radius for waypoint circles
my $waypointcircleradius = "auto";

## colors used for drawing tracks
## used in round-robin fashion
## tilesource==(white|transparent) overwrites this setting!
my @drawingcolors = (
    '#00dd00', '#0099ff', '#ff9900', '#99ff00', '#9900ff', '#ff0099',
    '#00ff99', '#dd0000', '#0000dd', '#cccc00', '#cc00cc', '#00cccc'
);

## drawing style of lower layer for tracks
## for colors see  @drawingcolors
## tilesource==(white|transparent) overwrites this setting!
my %drawingstylelowerlayer = ( linewidth => 4, fill => 'graya(0%, 0.0)' );

## drawing style of upper layer for tracks
## tilesource==(white|transparent) overwrites this setting!
my %drawingstyleupperlayer = ( stroke => '#ffffff', fill => 'graya(0%, 0.0)' );

## text style for copyright notice
my %copyrightnoticestyle = (
    fill       => 'graya(30%, 0.5)',
    pointsize  => 9,
    background => 'graya(90%, 0.5)',
    offset     => 2
);

## text style for scale
my %scalestyle = (
    fill       => 'graya(0%, 1.0)',
    pointsize  => 12,
    background => 'graya(100%, 0.7)',
    offset     => 8
);

## how to post-process the background image (all tiles)
## before drawing tracks on this background
my %backgroundpostprocess = ( saturation => 30.0, brightness => 110.0 );

# my %backgroundpostprocess = ( saturation => 0.0, brightness => 110.0 );

## caching directory, where to put the tiles followed by a file prefix
## default is current directory, prefix is "tile"
my $tilesprefix = "tile";

## tile URLs
my $baseurl        = "http://b.tile.openstreetmap.org/%d/%d/%d.png";
my $tilesourcename = "standard";
my $tilescopyright = "© OpenStreetMap contributors, CC BY-SA";

## geocache icon from OpenClipArt
my $geocacheiconurl =
  "http://www.openclipart.org/image/32px/svg_to_png/1270238622.png";
my $geocacheiconlocal = "/tmp/.geocacheicon.png";
## text style for geocache names
my %geocachestyle = (
    fill       => 'graya(0%, 1.0)',
    pointsize  => 12,
    background => 'graya(100%, 0.6)',
    offset     => 2
);

my $minxtile          = undef;
my $maxxtile          = undef;
my $minytile          = undef;
my $maxytile          = undef;
my $numxtiles         = undef;
my $numytiles         = undef;
my $pxwidth           = undef;
my $pxheight          = undef;
my $minlat            = undef;
my $minlong           = undef;
my $minx              = 1000000;
my $maxx              = -1000000;
my $miny              = 1000000;
my $maxy              = -1000000;
my $cutborder         = undef;
my $deltalat          = undef;
my $deltalong         = undef;
my $maxlat            = undef;
my $maxlong           = undef;
my @trkseglist        = ();
my @wptlist           = ();
my $image             = undef;
my %usedtiles         = ();
my @photolist         = ();
my $photosize         = 128;
my %geocaches         = ();
my $trackiconfilename = undef;
my $trackicondist     = 20;

$|             = 1;            # disable buffering of print/STDOUT
$main::VERSION = "20120415";

my $ua = LWP::UserAgent->new(
    agent      => "gpx2png",
    keep_alive => 1,
    env_proxy  => 1,
);

## parse command line parameters, set internal variables
sub parseCmdLineParam {
    my $getoptlongresult = GetOptions(
        "help|h" => sub {
            HELP_MESSAGE();
            exit 0;
        },
        ## create animation steps by saving individual images
        ## for each drawn track
        "animate|A" => \$doanimate,
        ## set sparse flag
        "sparse|s" => \$sparse,
        ## set quiet flag
        "quiet|q" => \$quiet,
        ## set output filename
        "output|o=s" => \$outputfilename,
        ## draw icons along a track like a dotted line
        "trackicon|i=s" => \$trackiconfilename,
        ## distance between track icons
        "trackicondist|I=i" => \$trackicondist,
        ## set photo thumbnail size
        "thumbnailsize|J=i" => \$photosize,
        ## one or more thumbnail filenames
        "thumbnail|j=s" => \@photolist,
        ## set zoom level
        "zoom|z=s" => sub {
            my $param = $_[1];
            if ( $param =~ /(\d+)/ && $1 >= 1 && $1 <= 16 ) {
                $zoom        = $1;
                $useautozoom = 0;
            }
            elsif ( $param eq "auto" ) {
                $zoom        = "auto";
                $useautozoom = 1;
            }
            else {
                die
"zoom level set but invalid; must be number in 1..16 or \"auto\"";
            }
        },
        ## set maximum number of tiles for autozoom
        "autozoom|a=i" => sub {
            my $param = $_[1];
            if ( $param =~ /(\d+)/ && $1 >= 1 && $1 <= 512 ) {
                $maxnumautotiles = $1;
                $zoom            = "auto";
                $useautozoom     = 1;
            }
            else {
                die
"maximum number of tiles for autozoom set but invalid; must be number in 1..512";
            }
        },
        ## set additional border tiles
        "bordertiles|b=i" => sub {
            my $param = $_[1];
            if ( $param =~ /(\d+)/ && $1 >= 0 && $1 <= 32 ) {
                $additionalborder = $1;
                print "Additional border tiles set to "
                  . $additionalborder . "\n"
                  if ( $quiet == 0 );
            }
            else {
                die
"additional border tiles set but invalid; must be number in 0..32";
            }
        },
        ## set cut border around drawn tracks
        "cutborder|c=i" => sub {
            my $param = $_[1];
            if ( $param =~ /(\d+)/ && $1 >= 0 && $1 <= 2048 ) {
                $cutborder = $1;
                print "Cut border size set to " . $cutborder . " pixel\n"
                  if ( $quiet == 0 );
            }
            else {
                die
                  "Cut border size set but invalid; must be number in 0..2048";
            }
        },
        ## set radius for waypoint circles
        "waypointradius|r=s" => sub {
            my $param = $_[1];
            if ( $param =~ /(\d+)/ && $1 >= 1 && $1 <= 512 ) {
                $waypointcircleradius = $1;
            }
            elsif ( $param eq "auto" ) {
                $waypointcircleradius = "auto";
            }
            else {
                die
"radius for waypoint circles set but invalid; must be number in 1..512 or \"auto\"";
            }
        },
        ## select source of images tiles
        "tiles|t=s" => sub {
            my $tilesource = $_[1];

            if ( $tilesource eq "cyclemap" || $tilesource eq "cycle" ) {
                $tilesourcename = "cyclemap";
                $baseurl = "http://a.tile.opencyclemap.org/cycle/%d/%d/%d.png";

                $tilescopyright = "Map data © OpenStreetMap contributors, CC BY-SA";
                $tilescopyright .= "; tiles by Andy Allan and Dave Stubbs";
            }
            elsif ( $tilesource eq "transport" ) {
                $tilesourcename = $tilesource;
                $baseurl =
                  "http://b.tile2.opencyclemap.org/transport/%d/%d/%d.png";

                $tilescopyright = "Map data © OpenStreetMap contributors, CC BY-SA";
                $tilescopyright .= "; tiles courtesy of Andy Allan and Dave Stubbs";
            }
            elsif ( $tilesource eq "opnvkarte" || $tilesource eq "oepnvkarte" )
            {
                $tilesourcename = "opnvkarte";
                $baseurl =
                  "http://tile.xn--pnvkarte-m4a.de/tilegen/%d/%d/%d.png";
                $tilescopyright = "Map data © OpenStreetMap contributors, CC BY-SA";
                $tilescopyright .= "; tiles courtesy of Melchior Moos";
            }
            elsif ( $tilesource eq "mapquest" ) {
                $tilesourcename = $tilesource;
                $baseurl =
                  "http://otile3.mqcdn.com/tiles/1.0.0/osm/%d/%d/%d.png";
                $tilescopyright = "Map data © OpenStreetMap contributors, CC BY-SA";
                $tilescopyright .= "; tiles courtesy of MapQuest";
            }
            elsif ( $tilesource eq "toner" ) {
                $tilesourcename = $tilesource;
                $baseurl        = "http://c.tile.stamen.com/toner/%d/%d/%d.png";
                $tilescopyright = "Map data © OpenStreetMap contributors, CC BY-SA";
                $tilescopyright .= "; tiles courtesy of Stamen Design";
            }
            elsif ( $tilesource eq "toner-lines" ) {
                $tilesourcename = $tilesource;
                $baseurl = "http://c.tile.stamen.com/toner-lines/%d/%d/%d.png";
                $tilescopyright = "Map data © OpenStreetMap contributors, CC BY-SA";
                $tilescopyright .= "; tiles courtesy of Stamen Design";
            }
            elsif ( $tilesource eq "white" ) {
                $tilesourcename = "white";
                $baseurl        = undef;
                $tilescopyright = undef;
            }
            elsif ( $tilesource eq "transparent" ) {
                $tilesourcename = undef;
                $baseurl        = undef;
                $tilescopyright = undef;
            }

            if (   ( $tilesource eq "white" )
                || ( $tilesource eq "transparent" ) )
            {

                # switch to grayscale drawing, which allows to draw tracks
                # in layers of adding shades of gray
                @drawingcolors = ('graya(0%, 0.0)');
                %drawingstylelowerlayer =
                  ( linewidth => 1, fill => 'graya(0%, 0.0)' );
                %drawingstyleupperlayer =
                  ( stroke => 'graya(0%, 0.4)', fill => 'graya(0%, 0.0)' );
            }
        }
    );

    ## print all set flags (if not quiet)
    if ( $quiet == 0 ) {
        print "Sparse mode is " . ( $sparse == 1 ? "ON" : "OFF" ) . "\n";
        print "Using tile images from \"" . $tilesourcename . "\"\n"
          if ( defined($tilesourcename) );
        print "Using white background\n" if ( !defined($tilesourcename) );
        print "Zoom level is " . $zoom;
        if ( $useautozoom > 0 ) {
            print " with at most " . $maxnumautotiles . " tiles";
        }
        print "\n";
        print "Pixel size of thumbnail photos is " . $photosize . "\n";
        print "There "
          . ( $#photolist == 0 ? "is" : "are" ) . " "
          . ( $#photolist < 0  ? "no" : 1 + $#photolist )
          . " thumbnail photo"
          . ( $#photolist == 0 ? "" : "s" )
          . " given\n";
        print "Output file is " . $outputfilename . "\n";
        print "Using icon \""
          . $trackiconfilename
          . "\" to draw track, icon distance is "
          . $trackicondist
          . " pixels\n"
          if ( defined($trackiconfilename) );
    }
}

sub HELP_MESSAGE {
    print "\nThis programs converts .gpx files (GPS tracks) into PNG images\n";
    print "by using images tiles from the OpenStreetMap project\n";
    print "and drawing sequences of lines corresponding to GPS points.\n\n";
    print "Copyright 2009-2010 Thomas Fischer <fischer\@unix-ag.uni-kl.de>\n";
    print
"This code is released under the GNU Public Licence version 3 or any later version.\n\n";
    print "This script is called like\n";
    print "  perl gpx2png.pl [OPTIONS] [GPXFILES]\n\n";
    print
"Available options (all optional, default values will be used if not specified)\n";
    print
"  -o FILENAME   Output filename of the image. Default: $outputfilename\n";
    print "  -z N          Zoom level (number or \"auto\"). Default: $zoom\n";
    print
"  -a N          Autozoom: Do not use more than N tiles to draw tracks. Default: $maxnumautotiles\n";
    print
"  -b N          Additional map image tiles around the map. Default: $additionalborder\n";
    print
"  -c N          Cut final map to have N pixels around the drawn tracks. Default: "
      . ( !defined($cutborder) ? "none" : $cutborder . " pixel" ) . "\n";
    print
"  -r N          Radius for waypoint circles. Default: $waypointcircleradius\n";
    print "  -A            Create animation steps by saving individual images\n"
      . "                for each drawn track. Default: "
      . ( defined($doanimate) ? "on" : "off" ) . "\n";
    print
"  -t SOURCE     Select the source of image tiles. Possible values for SOURCE:\n";
    print "                   standard   (default)\n";
    print "                   cyclemap\n";
    print "                   opnvkarte\n";
    print "                   mapquest\n";
    print "                   toner\n";
    print "                   toner-lines\n";
    print "                   white (no tiles, uses grayscale drawing)\n";
    print "                   transparent (no tiles, uses grayscale drawing)\n";
    print
"  -s            Sparse mode: Include only tiles touched by GPS tracks. Default: off\n";
    print
      "  -q            Quiet mode: Do not print status output. Default: off\n";
    print
"  -j FILENAME   Show thumbnail of JPEG photo at the position as determined\n";
    print
"                by GPS coordinates in EXIF tag. Multiple -j options possible\n";
    print
"  -J N          Set size of JPEG photo thumbnails. Default: $photosize\n";
    print "  -i FILENAME   Draw icons along a track like a dotted line\n";
    print
"                Icons are rotated towards track's direction, up is forward\n";
    print
"  -I N          Distance between the center of two subsequent icons. Default: "
      . $trackicondist . "\n";
    print "\nGPS tracks (format .gpx) are passed as a list of filenames,\n";
    print "or the .gpx files' content is piped into gpx2png.pl\n";
}

## map latitude/longitude and zoom level to tile number (x/y)
sub getTileNumber {
    my ( $lat, $lon, $zoom ) = @_;

    my $xtile = int( ( $lon + 180 ) / 360 * ( 1 << $zoom ) );
    my $l     = log( tan( $lat * pi / 180 ) + sec( $lat * pi / 180 ) );
    my $ytile = int( ( 1 - $l / pi ) / 2 * ( 1 << $zoom ) );

    return ( ( $xtile, $ytile ) );
}

sub Project {
    my ( $X, $Y, $Zoom ) = @_;
    my $Unit  = 1 / ( 2**$Zoom );
    my $relY1 = $Y * $Unit;
    my $relY2 = $relY1 + $Unit;

# note: $LimitY = ProjectF(degrees(atan(sinh(pi)))) = log(sinh(pi)+cosh(pi)) = pi
# note: degrees(atan(sinh(pi))) = 85.051128..
#my $LimitY = ProjectF(85.0511);

    # so stay simple and more accurate
    my $LimitY = pi;
    my $RangeY = 2 * $LimitY;
    $relY1 = $LimitY - $RangeY * $relY1;
    $relY2 = $LimitY - $RangeY * $relY2;
    my $Lat1 = ProjectMercToLat($relY1);
    my $Lat2 = ProjectMercToLat($relY2);
    $Unit = 360 / ( 2**$Zoom );
    my $Long1 = -180 + $X * $Unit;
    return ( ( $Lat2, $Long1, $Lat1, $Long1 + $Unit ) );    # S,W,N,E
}

sub ProjectMercToLat($) {
    my $MercY = shift();
    return ( 180 / pi * atan( sinh($MercY) ) );
}

sub ProjectF {
    my $Lat = shift;
    $Lat = deg2rad($Lat);
    my $Y = log( tan($Lat) + ( 1 / cos($Lat) ) );
    return ($Y);
}

## create URL to fetch tile depending on x/y numbering and zoom level
sub getURL {
    my ( $x, $y, $zoom ) = @_;
    return sprintf( $baseurl, $zoom, $x, $y );
}

## create file name to store/cache a tile depending on x/y numbering and zoom level
sub getFilename {
    my ( $x, $y, $zoom ) = @_;
    return
      sprintf( $tilesprefix . "-" . $tilesourcename . "-z%03d-x%05d-y%05d.png",
        $zoom, $x, $y );
}

## download a remove file given an URL and store it in a given local filename
sub downloadFile {
    my ( $url, $localfilename ) = @_;

    my $res = $ua->simple_request( HTTP::Request->new( GET => $url ) );
    if ( $res->code == 200 ) {
        open( FILE, ">$localfilename" )
          || die "Can't open $localfilename: $!\n";
        binmode FILE;
        print FILE $res->content;
        close FILE;
    }
    else {
        print "\n";
        die "Cannot download file $url";
    }
}

## read GPX data from a file handle and store line segment points in @trkseglist and waypoints in @wptlist
sub readGPXfromFile {
    my $handle             = $_[0];
    my @internaltrkseglist = ();
    my $retrkpt            = qr/trkpt\s+([^>]+)/;
    my $relat              = qr/lat=["']([-0-9.]+)["']/;
    my $relon              = qr/lon=["']([-0-9.]+)["']/;
    my $retrkseg           = qr/\/trkseg/;
    my $rewpt    = qr/^<wpt lat=["']([-0-9.]+)["'] lon=["']([-0-9.]+)["']/;
    my $rewpttag = qr/<([^>]+)>(.*?)<\/\1>/;
    my $rewptend = qr/\/wpt/;

    while (<$handle>) {
        if ( $_ =~ $retrkpt ) {
            my $line = $1;
            ( my $lat ) = $line =~ $relat;
            ( my $lon ) = $line =~ $relon;
            push @internaltrkseglist, [ ( $lat, $lon ) ];
        }
        elsif ( $_ =~ $retrkseg ) {
            print "Segment with " . @internaltrkseglist . " points\n"
              if ( $quiet == 0 );
            if ( @internaltrkseglist > 1 ) {
                push @trkseglist, [@internaltrkseglist];
                @internaltrkseglist = ();
            }
        }
        elsif ( $_ =~ $rewpt ) {
            push @wptlist, [ ( $1, $2 ) ];

     # check if waypoint is geocache by reading the waypoint's name and sym tags
            my $mapkey     = $1 . "_" . $2;
            my $isgeocache = 0;
            my $name       = undef;
            while (<$handle>) {
                if ( $_ =~ $rewpttag ) {
                    if ( $1 eq "sym" && $2 eq "Geocache" ) {
                        $isgeocache = 1;
                    }
                    elsif ( $1 eq "name" ) {
                        $name = $2;
                    }
                }
                elsif ( $_ =~ $rewptend ) {
                    last;
                }
            }
            if ( $isgeocache > 0 && defined($name) ) {
                $geocaches{$mapkey} = $name;
            }
        }
    }
}

sub determineTiles {
    $minxtile = 1000000;
    $maxxtile = 0;
    $minytile = 1000000;
    $maxytile = 0;

    $zoom = 16 if ( $useautozoom > 0 );

    for my $trkseg (@trkseglist) {
        foreach my $trkpt ( @{$trkseg} ) {
            my ( $lat, $long ) = @{$trkpt};
            ( my $xtile, my $ytile ) = getTileNumber( $lat, $long, $zoom );
            if ( $xtile > $maxxtile ) { $maxxtile = $xtile; }
            if ( $ytile > $maxytile ) { $maxytile = $ytile; }
            if ( $xtile < $minxtile ) { $minxtile = $xtile; }
            if ( $ytile < $minytile ) { $minytile = $ytile; }
            $usedtiles{ $xtile . "|" . $ytile } = 1;
        }
    }
    for my $wpt (@wptlist) {
        my ( $lat, $long ) = @{$wpt};
        ( my $xtile, my $ytile ) = getTileNumber( $lat, $long, $zoom );
        if ( $xtile > $maxxtile ) { $maxxtile = $xtile; }
        if ( $ytile > $maxytile ) { $maxytile = $ytile; }
        if ( $xtile < $minxtile ) { $minxtile = $xtile; }
        if ( $ytile < $minytile ) { $minytile = $ytile; }
        $usedtiles{ $xtile . "|" . $ytile } = 1;
    }

    die
"Invalid input data, no coordinates given minxtile=$minxtile  maxxtile=$maxxtile  minytile=$minytile  maxytile=$maxytile"
      if ( $minxtile > $maxxtile || $minytile > $maxytile );

    # fetch more tiles around the area required to draw the tracks,
    # so that there is enough map space to cut away later
    my $cutborderadditionaltiles =
      defined($cutborder) ? int( ( $cutborder + 384 ) / 256 ) : 0;
    if ( $additionalborder < $cutborderadditionaltiles ) {
        $additionalborder = $cutborderadditionaltiles;
    }

    # consider additional border
    $maxxtile += $additionalborder;
    $maxytile += $additionalborder;
    $minxtile -= $additionalborder;
    $minytile -= $additionalborder;

    $numxtiles = $maxxtile - $minxtile + 1;
    $numytiles = $maxytile - $minytile + 1;
    $pxwidth   = $numxtiles * 256;
    $pxheight  = $numytiles * 256;

    ( undef, $minlat, $maxlong, undef ) =
      Project( $minxtile, $minytile, $zoom );
    ( $minlong, undef, undef, $maxlat ) =
      Project( $maxxtile, $maxytile, $zoom );

    $deltalat  = $maxlat - $minlat;
    $deltalong = $maxlong - $minlong;

    if ( $useautozoom > 0 ) {
        my $div = 0;
        while ( ( $numxtiles + 1 ) * ( $numytiles + 1 ) > $maxnumautotiles ) {
            ++$div;
            $numxtiles >>= 1;
            $numytiles >>= 1;
        }
        $pxwidth  = $numxtiles * 256;
        $pxheight = $numytiles * 256;

        $useautozoom = 0;
        if ( $div > 0 ) {
            $zoom -= $div;
            %usedtiles = ();
            print "Autozoom is setting zoom to " . $zoom . "\n"
              if ( $quiet == 0 );
            determineTiles();
        }
        else {
            print "Autozoom is setting zoom to " . $zoom . "\n";
        }
    }
}

## read all GPX data from files (ARGV) or STDIN and perform some analysis
sub readAllGPX {
    @trkseglist = ();
    @wptlist    = ();

    if ( @ARGV == 0 ) {
        print "Reading .gpx files from STDIN\n" if ( $quiet == 0 );
        print "Run this script with \"-h\" to get usage information\n"
          if ( $quiet == 0 );
        readGPXfromFile( \*STDIN );
    }
    else {
        for my $filename (@ARGV) {
            print "Reading file $filename\n" if ( $quiet == 0 );
            open( FILE, '<', $filename ) or next;
            readGPXfromFile( \*FILE );
            close(FILE);
        }
    }

    determineTiles();
}

## download all tile images required to draw the given GPX data
sub downloadTiles {
    if ( !defined($baseurl) || !defined($tilesourcename) ) {
        print "Using white or transparent background instead of tiles\n"
          if ( $quiet == 0 );
        return;
    }

    if ( $sparse == 0 ) {
        print "Using " . ( $numxtiles * $numytiles ) . " tiles\n"
          if ( $quiet == 0 );
    }
    else {
        print "Using " .
          keys(%usedtiles)
          . " tiles (out of "
          . ( $numxtiles * $numytiles )
          . " possible)\n"
          if ( $quiet == 0 );
    }

    for my $y ( $minytile .. $maxytile ) {
        for my $x ( $minxtile .. $maxxtile ) {
            my $url = getURL( $x, $y, $zoom );
            my $filename = getFilename( $x, $y, $zoom );

            if ( ( $sparse == 0 || defined( $usedtiles{ $x . "|" . $y } ) )
                && !-e "$filename" )
            {
                printf "Downloading tile (%6d|%6d)", $x, $y if ( $quiet == 0 );
                downloadFile( $url, $filename );
                print "\n" if ( $quiet == 0 );
            }
        }
    }
}

## create a background image by combining all tile images
## perform some post-processing on final background image
sub initializeBackgroundImage {
    my $size = ( $numxtiles * 256 ) . 'x' . ( $numytiles * 256 );
    print "Building background image of size " . $size if ( $quiet == 0 );

    $image = Image::Magick->new( size => $size );
    die "\nCannot create image" unless defined($image);
    my $w = $image->ReadImage('NULL:white');
    die "\n$w" if "$w";

    if ( defined($baseurl) && defined($tilesourcename) ) {
        for my $y ( $minytile .. $maxytile ) {
            for my $x ( $minxtile .. $maxxtile ) {
                my $filename = getFilename( $x, $y, $zoom );
                if ( ( $sparse == 0 || defined( $usedtiles{ $x . "|" . $y } ) )
                    && -e $filename )
                {
                    my $tileimage = Image::Magick->new;
                    $w = $tileimage->Read($filename);
                    die "\n$w" if "$w";

                    $image->Composite(
                        image   => $tileimage,
                        compose => 'Over',
                        x       => ( $x - $minxtile ) * 256,
                        y       => ( $y - $minytile ) * 256
                    );
                }
            }
        }

        $w = $image->Modulate(%backgroundpostprocess);
        die "\n$w" if "$w";
    }
    elsif ( defined($tilesourcename) && $tilesourcename eq "white" ) {
        $image->Draw(
            primitive => 'rectangle',
            method    => 'Replace',
            stroke    => 'white',
            fill      => 'white',
            points => "0,0 " . ( $numxtiles * 256 ) . "," . ( $numytiles * 256 )
        );
    }

    print "\n" if ( $quiet == 0 );
}

## determine pixel position for a coordinate relative to the tileimage
## where it is drawn on
sub getPixelPosForCoordinates {
    my ( $lon, $lat, $zoom ) = @_;
    my ( $xtile, $ytile ) = getTileNumber( $lat, $lon, $zoom );

    my $xoffset = ( $xtile - $minxtile ) * 256;
    my $yoffset = ( $ytile - $minytile ) * 256;

    my ( $south, $west, $north, $east ) = Project( $xtile, $ytile, $zoom );

    my $x = int( ( $lon - $west ) * 256 /  ( $east - $west ) + $xoffset );
    my $y = int( ( $lat - $north ) * 256 / ( $south - $north ) + $yoffset );

    if ( $x > $maxx ) { $maxx = $x; }
    if ( $x < $minx ) { $minx = $x; }
    if ( $y > $maxy ) { $maxy = $y; }
    if ( $y < $miny ) { $miny = $y; }

    return ( $x, $y );
}

## draw given trek segment as a sequence of lines with a given drawing style
sub drawTrekSegment {
    my @trkseg       = @{ $_[0] };
    my %drawingStyle = %{ $_[1] };

    my $pointseries = "";

    foreach my $trkpt (@trkseg) {
        my ( $long, $lat ) = @{$trkpt};

        my ( $x, $y ) = getPixelPosForCoordinates( $lat, $long, $zoom );
        $pointseries .= " " . $x . "," . $y;
    }

    $drawingStyle{points} = $pointseries;
    my $w = $image->Draw(%drawingStyle);
    die "\n$w" if "$w";

    print "." if ( $quiet == 0 );
}

## draw an icon at some x/y coordinates with a given rotation
sub drawIcon {
    my ( $iconfilename, $x, $y, $rot ) = @_;
    my $icon = new Image::Magick || return;
    $icon->Read($iconfilename);
    $icon->AffineTransform( rotate => $rot );
    my ( $width, $height ) = $icon->Get( 'width', 'height' );
    my $iconx = int( $x - $width / 2 );
    my $icony = int( $y - $height / 2 );
    $image->Composite(
        image   => $icon,
        compose => 'Over',
        x       => $iconx,
        y       => $icony
    );
}

sub drawTreckSegmentWithArrows {
    my @trkseg = @{ $_[0] };
    my ( $lastx, $lasty ) = ( undef, undef );

    foreach my $trkpt (@trkseg) {
        my ( $long, $lat ) = @{$trkpt};
        my ( $x, $y ) = getPixelPosForCoordinates( $lat, $long, $zoom );
        if ( defined($lastx) ) {
            my $deltax = $lastx - $x;
            my $deltay = $lasty - $y;
            my $rot    = atan2( $deltay, $deltax ) * 180 / 3.1415 - 90;
            if ( $deltax * $deltax + $deltay * $deltay >
                $trackicondist * $trackicondist )
            {
                drawIcon( $trackiconfilename, $x, $y, $rot );
                $lastx = $x;
                $lasty = $y;
            }
        }
        else {
            $lastx = $x;
            $lasty = $y;
        }
    }
}

## draw given waypoint as a circle with a given drawing style
sub drawWaypoint {
    my ( $long, $lat ) = @{ $_[0] };
    my %drawingStyle = %{ $_[1] };

    if ( $waypointcircleradius eq "auto" ) {
        $waypointcircleradius = int( ( $numxtiles + $numytiles ) / 3 );
        print "Waypoint circle radius set to " . $waypointcircleradius . "\n"
          if ( $quiet == 0 );
    }

    my ( $x, $y ) = getPixelPosForCoordinates( $lat, $long, $zoom );

    my $geocachename = $geocaches{ $long . "_" . $lat };
    if ( defined($geocachename) ) {
        unless ( -e $geocacheiconlocal ) {

            # download small icon for geocaches
            downloadFile( $geocacheiconurl, $geocacheiconlocal );
        }

        # load and draw small icon for geocaches
        my $iconimage = Image::Magick->new;
        my $w         = $iconimage->Read($geocacheiconlocal);
        die "\n$w" if "$w";
        my ( $width, $height ) = $iconimage->Get( 'width', 'height' );
        $image->Composite(
            image   => $iconimage,
            compose => 'Over',
            x       => ( $x - $width / 2 ),
            y       => ( $y - $height / 2 )
        );

        # draw filled rectangle and text with geocache name (GC....)
        my %textparam = %geocachestyle;
        $textparam{x}     = $x;
        $textparam{y}     = $y;
        $textparam{align} = "Center", $textparam{text} = $geocachename;
        $textparam{y} += $height - $textparam{offset};
        ( undef, undef, undef, undef, $width, $height ) =
          $image->QueryFontMetrics(%textparam);
        $image->Draw(
            fill      => $textparam{background},
            primitive => 'rectangle',
            points    => ""
              . ( $x - $width / 2 - $textparam{offset} ) . ","
              . ( $textparam{y} + $textparam{offset} ) . " "
              . ( $x + $width / 2 + $textparam{offset} ) . ","
              . ( $textparam{y} - $height )
        );
        $image->Annotate(%textparam);
    }
    else {

        # not a geocache, draw plain circle
        my $x1 = $x - $waypointcircleradius;
        my $y1 = $y - $waypointcircleradius;
        my $x2 = $x + $waypointcircleradius;
        my $y2 = $y + $waypointcircleradius;

        $drawingStyle{points} = "$x1,$y1 $x2,$y2";

        my $w = $image->Draw(%drawingStyle);
        die "\n$w" if "$w";
    }

    print "." if ( $quiet == 0 );
}

## draw all GPX tracks first with on a "lower" layer and then on an "upper" layer
sub drawAllTracks {
    print "Drawing tracks " if ( $quiet == 0 );

    my $filenamepattern = $outputfilename;
    $filenamepattern =~ s/.png$/\%05d.png/i;

    my $colorcounter = 0;
    for my $trkseg (@trkseglist) {
        if ( defined($trackiconfilename) ) {
            drawTreckSegmentWithArrows( \@{$trkseg} );
        }
        else {
            my %drawingStyle = (%drawingstylelowerlayer);
            $drawingStyle{primitive} = 'polyline';
            $drawingStyle{stroke} =
              $drawingcolors[ ( ++$colorcounter ) % @drawingcolors ];
            drawTrekSegment( \@{$trkseg}, \%drawingStyle );

            %drawingStyle = (%drawingstyleupperlayer);
            $drawingStyle{primitive} = 'polyline';
            drawTrekSegment( \@{$trkseg}, \%drawingStyle );
        }

        if ( defined($doanimate) ) {
            my $filename = sprintf( $filenamepattern, $colorcounter );
            $image->Write($filename);
        }
    }

    print "\n" if ( $quiet == 0 );
}

## draw all GPX waypoints first with on a "lower" layer and then on an "upper" layer
sub drawAllWaypoints {
    return unless @wptlist > 0;

    print "Drawing waypoints " if ( $quiet == 0 );

    my %drawingStyle = (%drawingstylelowerlayer);
    $drawingStyle{primitive} = 'circle';
    $drawingStyle{fill}      = 'none';
    my $colorcounter = 0;
    for my $wpt (@wptlist) {
        $drawingStyle{stroke} =
          $drawingcolors[ ( ++$colorcounter ) % @drawingcolors ];
        drawWaypoint( \@{$wpt}, \%drawingStyle );
    }

    %drawingStyle            = (%drawingstyleupperlayer);
    $drawingStyle{primitive} = 'circle';
    $drawingStyle{fill}      = 'none';
    for my $wpt (@wptlist) {
        drawWaypoint( \@{$wpt}, \%drawingStyle );
    }
    print "\n" if ( $quiet == 0 );
}

## cut image so that a define minimum number of pixels is left around any coordinate
sub cutImage {
    if ( defined($cutborder) ) {
        $pxwidth  = int( $maxx - $minx + 2 * $cutborder );
        $pxheight = int( $maxy - $miny + 2 * $cutborder );

        print "Cutting image to size " . $pxwidth . "x" . $pxheight . "\n";

        my $w =
          $image->Crop( geometry => $pxwidth . "x"
              . $pxheight . "+"
              . ( $minx - $cutborder ) . "+"
              . ( $miny - $cutborder ) );
        die "$w" if "$w";

        ## repage image
        $image->Set( page => "0x0+0+0" );
        die "$w" if "$w";
    }
}

## add a copyright statement according to http://wiki.openstreetmap.org/wiki/Legal_FAQ
sub addCopyright {
    my $offset    = $copyrightnoticestyle{offset};
    my %textparam = %copyrightnoticestyle;
    $textparam{x}       = $offset;
    $textparam{y}       = $offset;
    $textparam{gravity} = 'SouthEast';

    $textparam{text} =
      defined($tilescopyright)
      ? $tilescopyright
      : 'some empty text WQiIjJgGyY1237890';
    ( undef, undef, undef, undef, my $width, my $height ) =
      $image->QueryFontMetrics(%textparam);
    if ( defined($tilescopyright) ) {
        $image->Draw(
            fill      => $copyrightnoticestyle{background},
            primitive => 'rectangle',
            points    => ""
              . ( $pxwidth - $width - 2 * $offset ) . ","
              . ( $pxheight - $height - 2 * $offset )
              . " $pxwidth,$pxheight"
        );
        $image->Annotate(%textparam);
        $textparam{y} =
          $height + 3 * $offset + 1;    ## set y-coordinate for annotation below
    }

    $textparam{text} =
      "Generated with gpx2png $main::VERSION, © Th. Fischer, GPL 3";
    ( undef, undef, undef, undef, $width, $height ) =
      $image->QueryFontMetrics(%textparam);
    $image->Draw(
        fill      => $copyrightnoticestyle{background},
        primitive => 'rectangle',
        points    => ""
          . ( $pxwidth - $width - 2 * $offset ) . ","
          . ( $pxheight - $textparam{y} - $height - $offset )
          . " $pxwidth,"
          . ( $pxheight - $textparam{y} + $offset )
    );
    $image->Annotate(%textparam);
}

## add a legend
sub drawScale {
    my @lenghtScaleLine =
      ( 0, 64, 51, 51, 51, 41, 41, 82, 82, 65, 65, 65, 52, 52, 52, 42, 42 );
    my @textScaleLine = (
        0,        '5000 km', '2000 km', '1000 km', '500 km', '200 km',
        '100 km', '100 km',  '50 km',   '20 km',   '10 km',  '5 km',
        '2 km',   '1000 m',  '500 m',   '200 m',   '100 m'
    );
    my $borderdist = $scalestyle{offset};
    my $lenght     = $borderdist + $lenghtScaleLine[$zoom];
    my $y          = $pxheight - $borderdist;
    $image->Draw(
        fill      => "black",
        stroke    => "black",
        primitive => "rectangle",
        points    => "$borderdist,$y $lenght," . ( $y - 3 )
    );
    $image->Draw(
        fill      => "white",
        stroke    => "white",
        primitive => "rectangle",
        points    => "$borderdist," . ( $y - 1 ) . " $lenght," . ( $y - 2 )
    );

    $y -= 7;
    $scalestyle{text} = $textScaleLine[$zoom];
    $scalestyle{x}    = $borderdist + 2;
    $scalestyle{y}    = $y - 2;
    ( undef, undef, undef, undef, my $width, my $height ) =
      $image->QueryFontMetrics(%scalestyle);
    $image->Draw(
        fill      => $scalestyle{background},
        primitive => 'rectangle',
        points    => ""
          . ( $width + $borderdist + 4 ) . ","
          . ( $y - $height )
          . " $borderdist,"
          . $y
    );
    $image->Annotate(%scalestyle);
}

## save final image (background and tracks) to output filename
sub saveImage {
    print "Saving to file " . $outputfilename if ( $quiet == 0 );
    my $w = $image->Write($outputfilename);
    die "$w"   if "$w";
    print "\n" if ( $quiet == 0 );
}

## read Exif comments from file containing GPS coordinates
## requires external program "exiv2" (http://www.exiv2.org/)
sub exifgpscoordinates {
    my ($jpegfilename) = @_;
    open( EXIV2, "exiv2 pr -Ptk \"" . $jpegfilename . "\"|" ) || return undef;
    my @gpslines = grep( /^Exif\.GPSInfo\.GPS/, <EXIV2> );
    close(EXIV2);

    chomp(@gpslines);
    my $gpstext = "#" . join( "#", @gpslines );
    my ( $londeg, $lonmin ) =
      $gpstext =~ m/Exif.GPSInfo.GPSLongitude\s+([-0-9]+)deg\s+([0-9.]+)'/;
    my ( $latdeg, $latmin ) =
      $gpstext =~ m/Exif.GPSInfo.GPSLatitude\s+([-0-9]+)deg\s+([0-9.]+)'/;
    my $lon    = $londeg + $lonmin / 60.0;
    my $lat    = $latdeg + $latmin / 60.0;
    my @result = ();
    push( @result, $lon );
    push( @result, $lat );

    return @result;
}

## draw thumbnails of photos on map
sub drawPhotos {
    if ( $#photolist < 0 ) { return; }

    print "Drawing photos " if ( $quiet == 0 );
    my @html = ();
    push( @html, "HTML text starts below\n" );
    push( @html, "<map name=\"gpx2png\">\n" );

    foreach my $jpegfilename (@photolist) {
        my $photo = new Image::Magick || next;
        $photo->Read($jpegfilename);
        my @lonlat = exifgpscoordinates($jpegfilename);
        next unless (@lonlat);
        my @xy = getPixelPosForCoordinates( $lonlat[0], $lonlat[1], $zoom );

        $photo->Scale( geometry => $photosize . "x" . $photosize );
        my ( $width, $height ) = $photo->Get( 'width', 'height' );
        my $x = int( $xy[0] - $width / 2 );
        my $y = int( $xy[1] - $height / 2 );
        $image->Composite(
            image   => $photo,
            compose => 'Over',
            x       => $x,
            y       => $y
        );
        print "." if ( $quiet == 0 );
        push( @html,
                "  <area shape=\"rect\" coords=\""
              . $x . ","
              . $y . ","
              . ( $x + $width ) . ","
              . ( $y + $height )
              . "\" href=\""
              . $jpegfilename
              . "\" />\n" );
    }
    push( @html, "</map>\n" );
    push( @html, "HTML text stops above\n" );
    print "\n" if ( $quiet == 0 );

    print join( "", @html ) if ( $quiet == 0 );
}

parseCmdLineParam();
readAllGPX();
downloadTiles();
initializeBackgroundImage();
drawAllTracks();
drawAllWaypoints();
drawPhotos();
cutImage();
drawScale();
addCopyright();
saveImage();

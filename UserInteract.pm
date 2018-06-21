#======================================================================
#  author | Lucien Ledune
#    date | 2018-16-06
#======================================================================
# Module incluant des fonctions utilisées pour intéragir avec l'utilisateur 
# pour le script Lyrics_Generator.pl
# Pour utiliser le module, lancer la fonction LyricsGenerator()
#======================================================================

package UserInteract;

use strict; 
use warnings; 
use EBook::EPUB::Lite;
use utf8; 
use Time::HiRes; 
use lib '.'; 
use extract; 

#Use this function to start asking user infos about songs and request lyrics. 
sub LyricsGenerator(){
	################################################### Requests
	#Trigger to know when user wants to stop
	my $trigger = 1; 

	#tabs containing later used infos
	my @artist;
	my @song;
	my @lyrics;

	#getting user song requests
	while($trigger ==1){
		#Ask user for song infos
		my @asked = askUser();
		
		#Push song into the respective tabs
		push(@artist, $asked[0]);
		push(@song, $asked[1]);
		
		#Asks if user wanrs another input
		print "Do you want to add more ? (enter 'n' to stop)\n";
		#The line tourine simply displays a line in the console
		line();
		
		my $check = <STDIN>;
		chomp($check);
		if(lc($check) eq "n"){
			$trigger = 0; 
		}
	}

	#Ask more infos for Epub
	print "\nAdditional informations about the Epub are required.\n";

	print "Title ?\n";
	my $title = <STDIN>;
	line();
	print "Author ?\n";
	my $author = <STDIN>;
	line();
	print "Language ?\n";
	my $language = <STDIN>;
	line();
	print "Date ? 'YYYY-MM-DD'\n";
	my $date = <STDIN>;
	line();
	print "Description ?\n";
	my $description = <STDIN>;
	line();
	print "Publisher ?\n";
	my $publisher = <STDIN>;
	line();

	#number of inputs
	my $length = @artist;

	#Get the lyrics for all the user inputs
	for(my $i = 0; $i < $length; $i++){
		my $tempLyrics = extract::getSongLyrics($artist[$i], $song[$i]);	
		push(@lyrics, $tempLyrics);
	}


	#################################################### EPUB
	my $epub = EBook::EPUB::Lite->new(); #new object for epub

	$epub->add_title($title);                    # titre
	$epub->add_author($author);                  # auteur
	$epub->add_language($language);              # langue
	$epub->add_date($date);                      # date
	$epub->add_description($description);        # description
	$epub->add_publisher($publisher);            # éditeur

	#Get link to the cover of book
	print "What is the full link to cover image ? (You can also use the name of the cover without full link if it is in the same directory)\n";
	my $coverLink = <STDIN>;
	chomp($coverLink);
	line();

	my $cover_id = $epub->copy_image($coverLink, 'cover.jpg') or die("Incorrect path");
	$epub->add_meta_item('cover', $cover_id);

	#Add cover as html page, displaying requested infos onto it
	my $cover_page = "<?xml version=\"1.0\" encoding=\"utf-8\"?>
	<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"
	  \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">
	  <html xmlns=\"http://www.w3.org/1999/xhtml\">
		<head><title></title><meta charset=\"utf-8\"></head>
		<body>
		<center>
		<font face = \"Arial\">
		<h1><b>$title</b></h1>
		<h3>$author</h3>
		<p>$description</p>
		<img src=\"$coverLink\"/>
		<p>$publisher - $date</p>
		</font>
		</center>
		</body>
	  </html>
	";

	my $cover_page_id = $epub->add_xhtml( 'cover.html', $cover_page );

	#For all songs, add a page with the title and lyrics. 
	for(my $i = 0; $i < $length; $i++){
	my $chapter = "<!DOCTYPE html>
	<html>
	<head>
		<title>Lyrics</title>
		<meta charset=\"utf-8\">
	</head>
	<body>
		<font face = \"Arial\">
		<h1>$artist[$i]</h1>
		<h2>$song[$i]</h2>
		 $lyrics[$i]
		</font>
	  </body> 
	</html>
	";
	my $chapter_01_id = $epub->add_xhtml( 'chapter_0'.$i.'.html', $chapter);
	}
	my $titleMod = $title;
	$titleMod =~ s/[\W_]//g;

	$epub->pack_zip("$titleMod.epub") or die("Couldn't generate the Epub.\n");

	#Just because it's more beautiful ;) 
	for(my $i = 0; $i < 10; $i++){
		Time::HiRes::usleep(100000);
		print ".\n";
	}

	print "OK\n";
	print "The EPub was successfully generated.\n\n";
}

#Ask user for a song parameters
sub askUser {
	print "Please enter the name of the artist : \n";
	my $artist = <STDIN>;
	line();
	chomp($artist);
	print "Please enter the title of the song : \n";
	my $song = <STDIN>;
	line();
	chomp($song);
	
	return my @asked = ($artist, $song);
}

#Asks user if he wants to proceed of if he wants to have some infos about the generation.
#returns the answer of user 'Y', 'N', or 'D'. 
sub detailsAsk{
my $trigger = 0;
	print "Welcome into Lyrics Generator. \n";
	print "Do you wish to Generate Lyrics now ? ('Y' to proceed, 'N' to abort, 'D' for details about the program. \n"; 
	
	my $answer;
	while($trigger == 0){
		$answer = <STDIN>; 
		chomp($answer);
		if((uc($answer) eq 'Y') or (uc($answer) eq 'N') or (uc($answer) eq 'D')){
		$trigger = 1; 
		}else{
			print "Please enter 'Y', 'N', or 'D'.";
		}
	}
	return uc($answer);
}

#Prints some details about program. 
sub Details{

	print "===============================================================\n";
	print "This program make use of perl to extract lyrics from the website azlyrics.com. 
	It asks for the user to input name of songs that he wants to request, then extracts them from the site 
	and creates an EPUB with those. It is also possible to add a cover page including a cover image
	to the EPUB file.
	Creator : Lucien Ledune (lucien.ledune\@student.uclouvain.be)\n";
	print "===============================================================\n\n";

}

sub line {
	print "===============================================================\n\n";
}


1;
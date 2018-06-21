#======================================================================
#  author | Lucien Ledune
#    date | 2018-01-06
#======================================================================
# Récupère les lyrics d'une chanson ou plusieurs sur le site azlyrics.
# Crée un EPUB contenant une couverture ainsi que les lyrics des 
# différentes chansons. 
#======================================================================
# usage
#   perl Lyrics_Generator.pl 
#======================================================================

use strict; 
use utf8; #Format used
use warnings; 
use EBook::EPUB::Lite; #Library for epub generation
use Time::HiRes; #Used for time sleep
use lib '.'; #Local modules
use extract; #extraction of lyrics 
use UserInteract; #Interaction with user

#Print title
title();

#Ask the user if he wants to start the program, abort, or ask for details about the program. 
#Keep doing it until n is pressed at the beginning of loop, when die() is executed.
while(1){
	my $answer = UserInteract::detailsAsk();
	answerHandle($answer);
}





#################################################### SubR

#Takes answer from usre as argument (details, proceed, abort) 
sub answerHandle{
my $answer = $_[0]; 
my $trigger = 1;
	if($answer eq 'Y'){
	while($trigger == 1){
		UserInteract::LyricsGenerator(); 
		line(); 
		print "Do you want to make another EPUB ? (Enter 'y' to keep going).\n"; 
		line();
		my $continue = <STDIN>;
		chomp($continue);
		if(lc($continue) eq 'y'){
			$trigger = 1; 
		}else{
			$trigger = 0;
			die("User aborted the program.")
		}
	}
}elsif($answer eq 'N'){
	line();
	die("Program aborted by user.\n "); 
	line();
}elsif($answer eq 'D'){
	line();
	UserInteract::Details;
	line();
}
}

sub title{
	print '


.____                   .__                                    
|    |    ___.__._______|__| ____   ______                     
|    |   <   |  |\_  __ \  |/ ___\ /  ___/                     
|    |___ \___  | |  | \/  \  \___ \___ \                      
|_______ \/ ____| |__|  |__|\___  >____  >                     
        \/\/                    \/     \/                      
  ________                                   __                
 /  _____/  ____   ____   ________________ _/  |_  ___________ 
/   \  ____/ __ \ /    \_/ __ \_  __ \__  \\   __\/  _ \_  __ \
\    \_\  \  ___/|   |  \  ___/|  | \// __ \|  | (  <_> )  | \/
 \______  /\___  >___|  /\___  >__|  (____  /__|  \____/|__|   
        \/     \/     \/     \/           \/                   


';
line();
}

sub line {
	print "===============================================================\n\n";
}




			

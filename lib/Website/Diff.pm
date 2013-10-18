use mop;
use feature 'say';

class Website::Diff {
    use Selenium::Remote::Driver;
    require MIME::Base64;
    use autodie;

    has $!ghost = Selenium::Remote::Driver->new(
        browser_name => 'phantomjs'
    );

    #$!ghost->evaluate('console.log("something else", document.getElementById("header").scrollIntoView(true))');
    has $!remove = q{
    var selector = arguments[0];
    var elem = window.document.querySelector(selector);
    elem.parentElement.removeChild(elem);
    };


    method process($a, $b, $selector) {
        say "diffing $a vs $b, removing $selector";

        $self->get_and_save($a, 'from.png', $selector);
        $self->get_and_save($b, 'to.png', $selector);

        $!ghost->quit;

        # Lets now do the diff images?
        say "composing difference image";
        say `composite from.png to.png -compose difference diff.png`;
        say "compose done, now compare";
        say `compare from.png to.png compare.png`;
    }
    method get_and_save($a, $file, $selector) {

        $!ghost->get($a);

        my $return = $!ghost->execute_script($!remove, $selector);
        say $!ghost->get_title;

        $self->save_screenshot($file);
    }

    method save_screenshot($filename) {
        open my $fh, ">", $filename;
        binmode($fh);
        print $fh MIME::Base64::decode_base64( $!ghost->screenshot );
        close $fh;
    }

}


1;

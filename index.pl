#!/usr/bin/perl

use warnings;
use strict;

use CGI;

#use CGI::Carp 'fatalsToBrowser';
use DBI;
use Encode ( 'decode', 'encode' );
use Data::Dumper;
use JSON;
use Template;

#use lib '/home/artur/code/Scheduler';
use Scheduler::Scheduler;

binmode STDOUT, ":encoding(utf8)";

my $cgi = CGI->new();
print $cgi->header( -type => 'text/html', -charset => 'utf-8' );

my %params = $cgi->Vars;

my $todo      = $params{'todo'};
my $user_id   = $params{'user_id'};
my $task_id   = $params{'task_id'};

my $template = Template->new( { INCLUDE_PATH => 'TT/', ENCODING => 'utf8', } );

my %todos = (
    'show_current_tasks' => \&show_current_tasks,
    'mark_task_as_done'  => \&mark_task_as_done,
    'show_log'           => \&show_log,
    'show_schedule'      => \&show_schedule,
);

my $vars = { 'user_id' => $user_id, };

sub show_current_tasks {

    my $file = 'current_tasks.tt';

    $vars->{'tasks'} =
      Scheduler::Scheduler::get_current_tasks( { user_id => $user_id, } );

    $template->process( $file, $vars ) or die $template->error();

    exit;
}

sub mark_task_as_done {

    my $result = Scheduler::Scheduler::mark_task_as_done(
        { user_id => $user_id, task_id => $task_id, } );
    
    print "Content-type: text/json\n\n";
    print to_json({'success' => 1}, { ascii => 1, pretty => 1 });

    return 1;
}

#sub save_schedule {}

sub show_schedule {
    
    my $file = 'edit_tasks.tt';
    
    my $schedule_data_href = Scheduler::Scheduler::show_schedule(
        { user_id => $user_id, task_id => $task_id, } );
        
    $vars->{'schedule_entries'}        = $schedule_data_href->{'schedule_entries'};
    $vars->{'allowed_doms'}            = $schedule_data_href->{'allowed_doms'};
    $vars->{'allowed_dows'}            = $schedule_data_href->{'allowed_dows'};
    $vars->{'allowed_months'}          = $schedule_data_href->{'allowed_months'};
    $vars->{'allowed_interval_types'}  = $schedule_data_href->{'allowed_interval_types'};
    $vars->{'allowed_interval_values'} = $schedule_data_href->{'allowed_interval_values'};
    
    $template->process( $file, $vars ) or die $template->error();
    
    return;
}

sub show_log {

    my $file = 'log.tt';

    $vars->{'log_entries'} = Scheduler::Scheduler::get_log_entries(
        { user_id => $user_id, task_id => $task_id, } );

    $template->process( $file, $vars ) or die $template->error();

    exit;
}

if ( exists $todos{$todo} ) {
    $todos{$todo}->('run');
}
else {
    $todos{'show_current_tasks'}->('run');
    print "invalid todo";

    # or better goto registration/welcome/startpage
}


#!/usr/bin/perl

use warnings;
use strict;

use CGI;

#use CGI::Carp 'fatalsToBrowser';
use DBI;
use Encode ( 'decode', 'encode' );
use Data::Dumper;
use Template;

#use lib '/home/artur/code/Scheduler';
use Scheduler::Scheduler;

my $cgi = CGI->new();
print $cgi->header( -type => 'text/html', -charset => 'utf-8' );

my %params = $cgi->Vars;

my $todo      = $params{'todo'};
my $user_id   = $params{'user_id'};
my $task_id   = $params{'task_id'};
my $task_name = $params{'task_name'};

my $template = Template->new( { INCLUDE_PATH => 'TT/', } );

my %todos = (
    'show_current_tasks' => \&show_current_tasks,
    'mark_task_as_done'  => \&mark_task_as_done,
    'show_log'           => \&show_log,
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

    show_current_tasks();
}

#sub save_schedule {}

#sub show_schedule {}

sub show_log {

    my $file = 'log.tt';

    $vars->{'task_name'}   = $task_name;
    $vars->{'log_entries'} = Scheduler::Scheduler::get_log_entries(
        { user_id => $user_id, task_id => $task_id, } );

    $template->process( $file, $vars ) or die $template->error();

    exit;
}

if ( exists $todos{$todo} ) {
    $todos{$todo}->('run');
}
else {
    print "invalid todo";

    # or better goto registration/welcome/startpage
}


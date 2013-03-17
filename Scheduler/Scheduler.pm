package Scheduler::Scheduler;

use warnings;
use strict;

use DBI;
use Encode ( 'decode', 'encode' );
binmode STDOUT, ":encoding(utf8)";

use Data::Dumper;

#use lib '/home/artur/public_html/Scheduler/';
use Scheduler::Schema;

# debug sql with DBIC_TRACE=1

my $dsn = 'dbi:mysql:scheduler:localhost';

my $schema = Scheduler::Schema->connect(
    $dsn, 'scheduler', '5ch3du13r',

    #{ 'mysql_enable_utf8' => 1 }
) or die "Es funktioniert nicht: " . $DBI::errstr;

sub get_current_tasks {
    my ($arg_href) = @_;
    my $user_id = $arg_href->{'user_id'};

    my @current_tasks;
    my %interval_for_task = ();
    my $schedule_rs =
      $schema->resultset('Schedule')->search( { 'user_id' => $user_id } );

    while ( my $row = $schedule_rs->next() ) {
        $interval_for_task{ $row->task_id } =
          $row->interval_value . " " . $row->interval_type;
    }

    foreach my $task_id ( keys %interval_for_task ) {

        my $sql =
"SELECT * FROM TASKS WHERE id = ? AND NOT EXISTS ( SELECT 1 FROM LOG WHERE task_id=? AND DATE_ADD(dt_done, INTERVAL $interval_for_task{ $task_id }) > NOW() )";

        # oder
        $sql =
"SELECT * FROM TASKS WHERE id = 2 AND id NOT IN ( SELECT task_id FROM LOG WHERE task_id=2 AND DATE_ADD(dt_done, INTERVAL 2 WEEK) > NOW() )";
        my $scalar    = " > NOW()";
        my $inside_rs = $schema->resultset('Log')->search(
            {
                'task_id' => $task_id,
                "DATE_ADD(dt_done, INTERVAL $interval_for_task{ $task_id })" =>
                  \$scalar,
            }
        );

        my $tasks_rs = $schema->resultset('Task')->search(
            {
                'id' => $task_id,

                # the blank in the key is put there intentionally to avoid
                # overwriting the first, homonymous key
                'id ' =>
                  { -not_in => $inside_rs->get_column('task_id')->as_query }
            },
        );

        while ( my $row = $tasks_rs->next() ) {
            push @current_tasks,
              {
                name        => encode( 'utf8', $row->name ),
                description => encode( 'utf8', $row->description ),
                id          => $task_id,
              };
        }
    }

    return \@current_tasks;
}

sub mark_task_as_done {
    my ($arg_href) = @_;
    my $user_id = $arg_href->{'user_id'} // return;
    my $task_id = $arg_href->{'task_id'} // return;

    my $result =
      $schema->resultset('Log')
      ->create( { user_id => $user_id, task_id => $task_id, } );

    return $result;
}

sub get_log_entries {
    my ($arg_href) = @_;
    my $user_id = $arg_href->{'user_id'} // return;
    my $task_id = $arg_href->{'task_id'};

    my @log_entries;
    
    # If user_id and task_id are given, show the history
    # for this user and task. If only user_id is given,
    # show history for all tasks of this user.
    my %where_conditions;
    $where_conditions{ 'user_id' } = $user_id;
    $where_conditions{ 'task_id' } = $task_id if $task_id;

    my $log_rs = $schema->resultset('Log')->search(
        {
            %where_conditions,
        },
        {
            'select' => [ 'task.name', 'task_id', { DATE => 'dt_done' } ],
            'as'   => [ 'task_name', 'task_id', 'date_done' ],
            'rows' => 50,
            'order_by' => { -desc => 'dt_done' },
            'join'     => 'task',
        }
    );

    while ( my $result = $log_rs->next() ) {
        push @log_entries,
          { 'dt_done' => $result->get_column('date_done'),
            'task_name' => $result->get_column('task_name'), };
    }

    #print Dumper \@log_entries; exit;
    return \@log_entries;
}

1;

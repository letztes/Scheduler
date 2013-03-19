package Scheduler::Scheduler;

use warnings;
use strict;
use utf8;

use DBI;
use Encode ( 'decode', 'encode' );

use Data::Dumper;

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
    
    # Fetches schedule info per task.
    # In order to build the sqls for query whether task is
    # done or not yet done.
    my $schedule_rs =
      $schema->resultset('Schedule')->search( { 'user_id' => $user_id } );

    while ( my $row = $schedule_rs->next() ) {
        $interval_for_task{ $row->task_id } =
          $row->interval_value . " " . $row->interval_type;
    }
    
    

    foreach my $task_id ( keys %interval_for_task ) {

        # Subquery returns all done tasks from log.
        # In order to exclude them from those not yet done.
        my $scalar    = " > NOW()";
        my $inside_rs = $schema->resultset('Log')->search(
            {
                'task_id' => $task_id,
                "DATE_ADD(dt_done, INTERVAL $interval_for_task{ $task_id })" =>
                  \$scalar,
            }
        );
        
        # The actual query for those tasks not yet done.
        # Utilizes the subquery defined above.
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
                name        => $row->name,
                description => $row->description,
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
          {
            'dt_done' => $result->get_column('date_done'),
            'task_name' => $result->get_column('task_name'),
            'task_id'   => $result->task_id,
          };
    }

    return \@log_entries;
}

sub show_schedule {
    my ($arg_href) = @_;
    my $user_id = $arg_href->{'user_id'} // return;
    my $task_id = $arg_href->{'task_id'};
    
    my @schedule_entries;
    
    my %where_conditions;
    $where_conditions{ 'user_id' } = $user_id;
    $where_conditions{ 'task_id' } = $task_id if $task_id;
    
    my $schedule_rs = $schema->resultset('Schedule')->search(
        {
            %where_conditions,
        },
        {
            '+select'  => ['task.name','task.description'],
            '+as'      => ['task_name','task_description'],
            'join'     => 'task',
        }
    );
    
    while ( my $result = $schedule_rs->next() ) {
        #warn Dumper \$result->get_columns();
        push @schedule_entries,
            {
                'id'             => $result->id,
                'task_name'      => $result->get_column('task_name'),
                'task_description'      => $result->get_column('task_description'),
                'user_id'        => $result->user_id,
                'task_id'        => $result->task_id,
                'interval_type'  => $result->interval_type,
                'interval_value' => $result->interval_value,
                'dom'            => $result->dom,
                'dow'            => $result->dow,
                'month'          => $result->month,
            }
    }
    
    return( {
        'schedule_entries'        => \@schedule_entries,
        'allowed_doms'            => get_allowed_doms(),
        'allowed_dows'            => get_allowed_dows(),
        'allowed_months'          => get_allowed_months(),
        'allowed_interval_types'  => get_allowed_interval_types(),
        'allowed_interval_values' => get_allowed_interval_values(),
    });
}

sub get_allowed_doms {
    
    return( [ undef, (1..31) ] );
}

sub get_allowed_months {
    
    # TODO: separate database table DOWS:
    # (id, name, index COMMENT('1=january,12=december'), lang)
    
    return( [ undef, qw( Jan Feb Mär Apr Mai Jun Jul Aug Sep Okt Nov Dez ) ] );
}

sub get_allowed_interval_values {
    
    return( [ undef, (1..50) ] );
}

sub get_allowed_interval_types {
    
    # TODO: separate database table interval_types:
    # (id, name, english_name COMMENT('english names are hash keys'), lang)
    
    # The first element is for index 0 resp. NULL/undef
    return( [ undef, qw( day week month year ) ] );
}

sub get_allowed_dows {
    
    # TODO: separate database table DOWS:
    # (id, name, index COMMENT('1=monday,7=sunday'), lang)
    
    # The first element is for index 0 resp. NULL/undef
    return( [ undef, qw( Mo Di Mi Do Fr Sa So) ] );
}

1;

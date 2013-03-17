use utf8;
package Scheduler::Schema::Result::Task;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Scheduler::Schema::Result::Task

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<TASKS>

=cut

__PACKAGE__->table("TASKS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 2048

=head2 date_insert

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 date_update

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "description",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 2048 },
  "date_insert",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "date_update",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 logs

Type: has_many

Related object: L<Scheduler::Schema::Result::Log>

=cut

__PACKAGE__->has_many(
  "logs",
  "Scheduler::Schema::Result::Log",
  { "foreign.task_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 schedules

Type: has_many

Related object: L<Scheduler::Schema::Result::Schedule>

=cut

__PACKAGE__->has_many(
  "schedules",
  "Scheduler::Schema::Result::Schedule",
  { "foreign.task_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-02-25 23:08:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:brtJgOCmBdGf1nFH3YGTug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

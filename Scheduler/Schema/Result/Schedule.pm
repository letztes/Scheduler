use utf8;
package Scheduler::Schema::Result::Schedule;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Scheduler::Schema::Result::Schedule

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<SCHEDULE>

=cut

__PACKAGE__->table("SCHEDULE");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 task_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 interval_type

  data_type: 'enum'
  extra: {list => ["day","week","month","year"]}
  is_nullable: 0

=head2 interval_value

  data_type: 'tinyint'
  is_nullable: 0

=head2 dom

  data_type: 'enum'
  extra: {list => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]}
  is_nullable: 1

day of month

=head2 dow

  data_type: 'enum'
  extra: {list => [1,2,3,4,5,6,7]}
  is_nullable: 1

day of week, where 1=monday and 7=sunday

=head2 month

  data_type: 'enum'
  extra: {list => [1,2,3,4,5,6,7,8,9,10,11,12]}
  is_nullable: 1

1=january and 12=december

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "task_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "interval_type",
  {
    data_type => "enum",
    extra => { list => ["day", "week", "month", "year"] },
    is_nullable => 0,
  },
  "interval_value",
  { data_type => "tinyint", is_nullable => 0 },
  "dom",
  { data_type => "enum", extra => { list => [1 .. 31] }, is_nullable => 1 },
  "dow",
  { data_type => "enum", extra => { list => [1 .. 7] }, is_nullable => 1 },
  "month",
  { data_type => "enum", extra => { list => [1 .. 12] }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 task

Type: belongs_to

Related object: L<Scheduler::Schema::Result::Task>

=cut

__PACKAGE__->belongs_to(
  "task",
  "Scheduler::Schema::Result::Task",
  { id => "task_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<Scheduler::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Scheduler::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-03-19 11:43:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V5NzUlqC405Te3JNnhT79Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

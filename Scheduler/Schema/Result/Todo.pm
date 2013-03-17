use utf8;
package Scheduler::Schema::Result::Todo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Scheduler::Schema::Result::Todo

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<TODO>

=cut

__PACKAGE__->table("TODO");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 task_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dt_todo

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
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
  "user_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "task_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "dt_todo",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-02-25 23:08:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UkmV8Xbb9N09cXvV4QkzMg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

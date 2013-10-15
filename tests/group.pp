supervisord::group { 'test':
  priority => '100',
  programs => ['program1', 'program2', 'program3']
}
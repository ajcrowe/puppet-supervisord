supervisord::program { 'test':
  command      => '/testcmd',
  process_name => '%(process_num)s',
  numprocs     => '3',
  priority     => '100',
  environment  => {
    env1 => 'env1',
    env2 => 'env2',
    env3 => 'env3'
  }
}
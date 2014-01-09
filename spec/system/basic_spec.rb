require 'spec_helper_system'

describe 'basic install' do

  it 'class should work with no errors' do
    pp = <<-EOS
      class { 'supervisord': install_pip  => true, install_init => true}
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should be_zero
    end
  end
end

describe 'add a program config' do

  it 'supervisord::program should install a program config' do

    pp = <<-EOS
      include supervisord
      supervisord::program { 'test': 
        command => 'echo', 
        priority => '100', 
        environment => { 
          'HOME' => '/root',
          'PATH' => '/bin',
        }
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should be_zero
    end

    shell("grep command=echo /etc/supervisor.d/program_test.conf") do |r|
      r.exit_code.should be_zero
    end
    shell("grep priority=100 /etc/supervisor.d/program_test.conf") do |r|
      r.exit_code.should be_zero
    end
    shell('grep "environment=" /etc/supervisor.d/program_test.conf') do |r|
      r.exit_code.should be_zero
    end
  end
end 

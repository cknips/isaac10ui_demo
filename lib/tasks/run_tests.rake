namespace :minitest do
  desc "Run all feature tests"
  task run_tests: :environment do
    test_files      = FileList.new(Rails.root.to_s + "/test/features/**/*.rb")
    # Tests in files are order dependent so do upgrade/downgrade/cancel
    # tests at the end
    up_down_files   =
      test_files.select do |file|
        file.include?("downgrade") || file.include?("upgrade")
      end
    cancel_file     = test_files.select { |file| file.include?("cancel") }
    run_first_files = test_files - up_down_files - cancel_file

    run_first_files.each do |file|
      sh "bundle exec rake test TEST=#{file}"
    end

    up_down_files.each do |file|
      sh "bundle exec rake test TEST=#{file}"
    end

    sh "bundle exec rake test TEST=#{cancel_file}"
  end
end

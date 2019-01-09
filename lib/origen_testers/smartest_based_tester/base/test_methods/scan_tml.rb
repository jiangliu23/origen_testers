module OrigenTesters
  module SmartestBasedTester
    class Base
      class TestMethods
        class ScanTml < BaseTml
          TEST_METHODS = {
            scan_test:                  {
              scan_pins:              [:string, '@'],
              max_fails_per_pin:      [:integer, -1],
              cycle_base:             [:string, '1'],
              include_expected_data:  [:string, '0'],
              tester_cycle_mode:      [:string, '1'],
              output:                 [:string, 'None', %w(None ReportUI ShowFailOnly)],
              cycle_number_per_label: [:string, 'false', %w(false true)],
              test_name:              [:string, 'ScanTest']
            }
          }

          def scan_test
            self
          end

          def klass
            'scan_tml.ScanTest'
          end
        end
      end
    end
  end
end

module OrigenTesters
  module SmartestBasedTester
    class Base
      class TestMethods
        class MultiGroupDcTml < BaseTml
          TEST_METHODS = {
            continuity: {
              'UsePPMU'                          => [:string, 'NO', %w(NO YES)],
              'UsePPMU.pinlist'                  => [:string, ''],
              'UsePPMU.testCurrent_uA'           => [:string, '10'],
              'UsePPMU.settlingTime_ms'          => [:string, '1'],
              'UsePPMU.measureMode'              => [:string, 'PAR', %w(PAR SER)],
              'UsePPMU.polarity'                 => [:string, 'SPOL', %w(SPOL DSPOL)],
              'UsePPMU.testName'                 => [:string, ''],
              'UseSPMU'                          => [:string, 'NO', %w(NO YES)],
              'UseSPMU.pinlist'                  => [:string, ''],
              'UseSPMU.testCurrent_uA'           => [:string, '10'],
              'UseSPMU.settlingTime_ms'          => [:string, '1'],
              'UseSPMU.polarity'                 => [:string, 'SPOL', %w(SPOL DSPOL)],
              'UseSPMU.measureMode'              => [:string, 'PAR', %w(PAR SER)],
              'UseSPMU.prechargeToZeroVol'       => [:string, 'ON', %w(ON OFF)],
              'UseSPMU.testName'                 => [:string, ''],
              'UseMCX-PMU'                       => [:string, 'NO', %w(NO YES)],
              'UseMCX-PMU.pinlist'               => [:string, ''],
              'UseMCX-PMU.testCurrent_uA'        => [:string, '10'],
              'UseMCX-PMU.settlingTime_ms'       => [:string, '1'],
              'UseMCX-PMU.measureMode'           => [:string, 'PAR', %w(PAR SER)],
              'UseMCX-PMU.polarity'              => [:string, 'SPOL', %w(SPOL DSPOL)],
              'UseMCX-PMU.testName'              => [:string, ''],
              'UseDCScaleDPS'                    => [:string, 'NO', %w(NO YES)],
              'UseDCScaleDPS.pinlist'            => [:string, ''],
              'UseDCScaleDPS.settlingTime_ms'    => [:string, '1'],
              'UseDCScaleDPS.polarity'           => [:string, 'SPOL', %w(SPOL DSPOL)],
              'UseDCScaleDPS.measureMode'        => [:string, 'PAR', %w(PAR SER)],
              'UseDCScaleDPS.specName'           => [:string, ''],
              'UseDCScaleDPS.specValue'          => [:string, '3.0'],
              'UseDCScaleDPS.testName'           => [:string, ''],
              'UseDPS'                           => [:string, 'NO', %w(NO YES)],
              'UseDPS.pinlist'                   => [:string, ''],
              'UseDPS.settlingTime_ms'           => [:string, '1'],
              'UseDPS.measureMode'               => [:string, 'PAR', %w(PAR SER)],
              'UseDPS.polarity'                  => [:string, 'SPOL', %w(SPOL DSPOL)],
              'UseDPS.specName'                  => [:string, ''],
              'UseDPS.specValue'                 => [:string, '3.0'],
              'UseDPS.testName'                  => [:string, ''],
              'UseDCScaleSIG'                    => [:string, 'NO', %w(NO YES)],
              'UseDCScaleSIG.pinlist'            => [:string, ''],
              'UseDCScaleSIG.testCurrent_uA'     => [:string, '10'],
              'UseDCScaleSIG.settlingTime_ms'    => [:string, '1'],
              'UseDCScaleSIG.polarity'           => [:string, 'SPOL', %w(SPOL DSPOL)],
              'UseDCScaleSIG.measureMode'        => [:string, 'PAR', %w(PAR SER)],
              'UseDCScaleSIG.prechargeToZeroVol' => [:string, 'ON', %w(ON OFF)],
              'UseDCScaleSIG.testName'           => [:string, ''],
              'output'                           => [:string, 'None', %w(None ReportUI ShowFailOnly)]
            },
            leakage:    {
              'UsePPMU'                           => [:string, 'NO', %w(NO YES)],
              'UsePPMU.pinlist'                   => [:string, ''],
              'UsePPMU.measure'                   => [:string, 'BOTH', %w(LOW HIGH BOTH)],
              'UsePPMU.forceVoltage_mV'           => [:string, '(400,3800)'],
              'UsePPMU.preCharge'                 => [:string, 'ON', %w(ON OFF)],
              'UsePPMU.prechargeVoltage_mV'       => [:string, '(0.0, 0.0)'],
              'UsePPMU.settlingTime_ms'           => [:string, '(1.0,1.2)'],
              'UsePPMU.measureMode'               => [:string, 'PAR', %w(PAR SER)],
              'UsePPMU.relaySwitchMode'           => [:string, 'DEFAULT(BBM)', ['DEFAULT(BBM)', 'MBB', 'PARALLEL']],
              'UsePPMU.testName'                  => [:string, ''],
              'UseSPMU'                           => [:string, 'NO', %w(NO YES)],
              'UseSPMU.pinlist'                   => [:string, ''],
              'UseSPMU.measure'                   => [:string, 'BOTH', %w(LOW HIGH BOTH)],
              'UseSPMU.forceVoltage_mV'           => [:string, '(400,3800)'],
              'UseSPMU.preCharge'                 => [:string, 'ON', %w(ON OFF)],
              'UseSPMU.prechargeVoltage_mV'       => [:string, '(0.0, 0.0)'],
              'UseSPMU.clampCurrent_uA'           => [:string, '(100,300)'],
              'UseSPMU.settlingTime_ms'           => [:string, '(1.0,1.2)'],
              'UseSPMU.measureMode'               => [:string, 'PAR', %w(PAR SER)],
              'UseSPMU.relaySwitchMode'           => [:string, 'NTBBM', %w(NTBBM NTMBB)],
              'UseSPMU.testName'                  => [:string, ''],
              'UseMCX-PMU'                        => [:string, 'NO', %w(NO YES)],
              'UseMCX-PMU.pinlist'                => [:string, ''],
              'UseMCX-PMU.measure'                => [:string, 'BOTH', %w(LOW HIGH BOTH)],
              'UseMCX-PMU.forceVoltage_mV'        => [:string, '(400,3800)'],
              'UseMCX-PMU.preCharge'              => [:string, 'ON', %w(ON OFF)],
              'UseMCX-PMU.prechargeVoltage_mV'    => [:string, '(0.0, 0.0)'],
              'UseMCX-PMU.measureMode'            => [:string, 'PAR', %w(PAR SER)],
              'UseMCX-PMU.settlingTime_ms'        => [:string, '(1.0,1.2)'],
              'UseMCX-PMU.testName'               => [:string, ''],
              'UseDcScaleSIG'                     => [:string, 'NO', %w(NO YES)],
              'UseDcScaleSIG.pinlist'             => [:string, ''],
              'UseDcScaleSIG.measure'             => [:string, 'BOTH', %w(LOW HIGH BOTH)],
              'UseDcScaleSIG.forceVoltage_mV'     => [:string, '(400,3800)'],
              'UseDcScaleSIG.preCharge'           => [:string, 'ON', %w(ON OFF)],
              'UseDcScaleSIG.prechargeVoltage_mV' => [:string, '(0.0,0.0)'],
              'UseDcScaleSIG.clampCurrent_uA'     => [:string, '(100,300)'],
              'UseDcScaleSIG.settlingTime_ms'     => [:string, '(1.0,1.2)'],
              'UseDcScaleSIG.measureMode'         => [:string, 'PAR', %w(PAR SER)],
              'UseDcScaleSIG.relaySwitchMode'     => [:string, 'NO', %w(NO NT)],
              'UseDcScaleSIG.testName'            => [:string, ''],
              'preFunction'                       => [:string, 'NO', %w(NO YES)],
              'preFunction.testName'              => [:string, ''],
              'checkFunction'                     => [:string, 'ON', %w(ON OFF)],
              'output'                            => [:string, 'None', %w(None ReportUI ShowFailOnly)],
              'stopCycHigh'                       => [:string, ''],
              'stopCycLow'                        => [:string, ''],
              'stopVecHigh'                       => [:string, '0'],
              'stopVecLow'                        => [:string, '0'],

              multi_limits: [{ id: 'PreFunctionalTest' }, { id: 'PreFunctionalTest_High' }, { id: 'PreFunctionalTest_Low' }]
            }
          }

          def multi_group_dc_test
            self
          end

          def klass
            'multi_group_dc_tml.DcTest'
          end
        end
      end
    end
  end
end

/* -*- C++ -*- */
#include "Test_Common.h"
#include "assert.h"
//#include "ExternalConfigFunctions.h"
#include "ExternalConfig_Test.h"
#include "ZStringByteSource.h"
#include "FileByteSink.h"  /* For STDERR */
#include "Element_Dreg.h"
#include "AbstractDriver.h"

namespace MFM
{
  struct TestDriver : public AbstractDriver<TestGridConfig>
  {
    TestDriver() : AbstractDriver<TestGridConfig>(1,1,GRID_LAYOUT_CHECKERBOARD) { }
    void ReinitEden() { FAIL(ILLEGAL_STATE); }
    void DefineNeededElements() { FAIL(ILLEGAL_STATE); }
  };


  static void TestBasic()
  {
    ElementRegistry<TestEventConfig> ereg;
    ereg.RegisterElement(Element_Dreg<TestEventConfig>::THE_INSTANCE);

    Grid<TestGridConfig> grid(ereg,4,3,GRID_LAYOUT_CHECKERBOARD); //default layout
    grid.SetSeed(1);
    grid.Init();

    TestDriver td;

    ExternalConfig<TestGridConfig> cfg(td);
    OverflowableCharBufferByteSink<1024> errs;
    cfg.SetErrorByteSink(errs);
    //    LOG.Error("DREG %@", &Element_Dreg<TestCoreConfig>::THE_INSTANCE.GetUUID());
    ZStringByteSource zbs("RegisterElement(Dreg-11113440820141119593847, d)\n"
                          "GA(d,30,31,0000000000000000)\n"
                          "GA(d,31,32,0123456789abcdef)\n"   // a.s. invalid value but nobody checks
                          "SetElementParameter(d,ddreg,10)\n");
    cfg.SetByteSource(zbs, "./configurations/ExternalConfig_Test.input");
    cfg.Read();

    if (errs.GetLength() > 0)
    {
      LOG.Debug("ExternalConfig_Test error output:\n%s",errs.GetZString());
    }

  }

  void ExternalConfig_Test::Test_RunTests()
  {
    TestBasic();
  }
}

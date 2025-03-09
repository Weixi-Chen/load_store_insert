#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Passes/PassBuilder.h"

using namespace llvm;

namespace {
struct InstrumentLoadStorePass : public PassInfoMixin<InstrumentLoadStorePass> {
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
        LLVMContext &Context = F.getContext();
        Module *M = F.getParent();
        IRBuilder<> Builder(Context);

        // Declare printf function
        FunctionCallee PrintfFunc = M->getOrInsertFunction(
            "printf", FunctionType::get(IntegerType::getInt32Ty(Context), 
                                        PointerType::get(Type::getInt8Ty(Context), 0), true)
        );

        for (BasicBlock &BB : F) {
            for (Instruction &I : BB) {
                if (auto *LI = dyn_cast<LoadInst>(&I)) {
                    Builder.SetInsertPoint(LI);
                    Builder.CreateCall(PrintfFunc, {Builder.CreateGlobalStringPtr("Load Detected\n")});
                }
                if (auto *SI = dyn_cast<StoreInst>(&I)) {
                    Builder.SetInsertPoint(SI);
                    Builder.CreateCall(PrintfFunc, {Builder.CreateGlobalStringPtr("Store Detected\n")});
                }
            }
        }

        return PreservedAnalyses::all();
    }
};
}

// Register the pass using the New Pass Manager API
llvm::PassPluginLibraryInfo getInstrumentLoadStorePass() {
    return {LLVM_PLUGIN_API_VERSION, "InstrumentLoadStorePass", LLVM_VERSION_STRING,
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM, ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "instrument-load-store") {
                        FPM.addPass(InstrumentLoadStorePass());
                        return true;
                    }
                    return false;
                });
        }};
}

// Ensure LLVM finds the plugin entry point
extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return getInstrumentLoadStorePass();
}
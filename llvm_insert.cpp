// IR instructions
#include "llvm/IR/IRBuilder.h"
// LLVM Pass frame, for modification of code at IR level
#include "llvm/IR/PassManager.h"
// LLVM Module
#include "llvm/IR/Module.h"
// Function Structure
#include "llvm/IR/Function.h"
// To identify LoadInst and StoreInst
#include "llvm/IR/Instructions.h"
// allow for output
#include "llvm/Support/raw_ostream.h"
// allow LLVM to detect the pass
#include "llvm/Passes/PassPlugin.h"
// alow LLVM to execute the pass
#include "llvm/Passes/PassBuilder.h"

using namespace llvm;

// Define LLVM Pass for IR modification
namespace {
struct InstrumentLoadStorePass : public PassInfoMixin<InstrumentLoadStorePass> {
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
        // get context
        LLVMContext &Context = F.getContext();
         // get the whole IR module
        Module *M = F.getParent();
        // for insertions for IR instructions
        IRBuilder<> Builder(Context);

        // Declare printf function
        FunctionCallee PrintfFunc = M->getOrInsertFunction(
            "printf", FunctionType::get(IntegerType::getInt32Ty(Context), 
                                        PointerType::get(Type::getInt8Ty(Context), 0), true)
        );

        // iterate through each block
        for (BasicBlock &BB : F) {
            // iterate through each instruction
            for (Instruction &I : BB) {
                // LOAD
                if (auto *LI = dyn_cast<LoadInst>(&I)) {
                    Builder.SetInsertPoint(LI);
                    // Insert print statement
                    Builder.CreateCall(PrintfFunc, {Builder.CreateGlobalStringPtr("Load Detected\n")});
                }
                // STORE
                if (auto *SI = dyn_cast<StoreInst>(&I)) {
                    Builder.SetInsertPoint(SI);
                    // Insert print statement
                    Builder.CreateCall(PrintfFunc, {Builder.CreateGlobalStringPtr("Store Detected\n")});
                }
            }
        }

        // return the result of pass
        return PreservedAnalyses::all();
    }
};
}

// Register the pass with LLVM
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
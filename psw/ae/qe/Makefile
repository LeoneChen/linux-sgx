#
# Copyright (C) 2011-2021 Intel Corporation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
#   * Neither the name of Intel Corporation nor the names of its
#     contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

TOP_DIR := ../../..
include ../buildenv.mk

# CXXFLAGS  += -Werror
# CFLAGS	+= -Werror
AENAME = quoting_enclave

EXTERNAL_LIB += -L$(EPID_SDK_DIR)/epid/member -lmember \
				-L$(EPID_SDK_DIR)/epid/common -lcommon

INCLUDE += -I$(LINUX_PSW_DIR)/ae/data/constants/linux \
           -I$(SGX_HEADER_DIR)/libcxx                 \
           -I$(LINUX_PSW_DIR)/ae/common	              \
           -I$(LINUX_PSW_DIR)/ae/inc/internal         \
           -I$(EPID_SDK_DIR) 


SRC := $(wildcard *.cpp)
SRC += se_sig_rl.cpp                  \
	   pve_qe_common.cpp 

OBJ := $(SRC:.cpp=.o)
OBJS := $(sort $(OBJ) version.o)

EPID_CFLAGS = \
	-fvisibility=hidden -fpie -fno-strict-overflow -fno-delete-null-pointer-checks \
	-fno-discard-value-names \
	-fsanitize-coverage=inline-8bit-counters,bb,no-prune,pc-table,trace-cmp
EPID_CXXFLAGS = \
	-fvisibility=hidden -fpie -fno-strict-overflow -fno-delete-null-pointer-checks \
	-fno-discard-value-names \
	-fsanitize-coverage=inline-8bit-counters,bb,no-prune,pc-table,trace-cmp
APP_NAME := FuzzQE
App_C_Flags := $(SGX_COMMON_CFLAGS) -fPIC -Wno-attributes $(INCLUDE) $(DEFINES) \
	-fsanitize-coverage=inline-8bit-counters,bb,no-prune,pc-table,trace-cmp \
	-fprofile-instr-generate \
	-fcoverage-mapping
App_Link_Flags := $(SGX_COMMON_CFLAGS) -L$(SGX_LIB_DIR) $(URTSLIB) $(UAE_SERVICE_LIB) -lpthread \
	-ldl \
	-Wl,-rpath=$(SGX_LIB_DIR) \
	-Wl,-whole-archive -lSGXSanRTApp -Wl,-no-whole-archive \
	-lSGXFuzzerRT \
	-lcrypto \
	-lboost_program_options \
	-rdynamic \
	-fuse-ld=${LD} \
	-fprofile-instr-generate
Enclave_Cpp_Flags := \
	-fno-discard-value-names \
	-flegacy-pass-manager \
	-Xclang -load -Xclang $(SGX_SDK)/lib64/libSGXSanPass.so \
	-fsanitize-coverage=inline-8bit-counters,bb,no-prune,pc-table,trace-cmp \
	-fprofile-instr-generate \
	-fcoverage-mapping
Enclave_Link_Flags := -fuse-ld=${LD} -fprofile-instr-generate -shared

.PHONY: all
all: $(SONAME) $(APP_NAME)

.PHONY: EPID
EPID:
	cd $(EPID_SDK_DIR) && CC="$(CC)" CXX="$(CXX)" CFLAGS="$(EPID_CFLAGS)" CXXFLAGS="$(EPID_CXXFLAGS)" ./configure prefix=/usr/local
	$(MAKE) -C $(EPID_SDK_DIR) 2> /dev/null

$(SONAME): $(OBJS) EPID
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDTFLAGS) $(Enclave_Link_Flags)
#	$(STRIP) --strip-unneeded --remove-section=.comment --remove-section=.note $(SONAME)

$(OBJ): $(AENAME)_t.c
$(OBJ): %.o: %.cpp
	$(CXX) $(CXXFLAGS) $(Enclave_Cpp_Flags) -fno-exceptions -fno-rtti $(INCLUDE) $(DEFINES) -c $< -o $@

$(AENAME)_t.c: $(EDLFILE)
	@$(EDGER8R) --trusted $< --search-path $(SGX_HEADER_DIR)

# Generate FuzzerQE
$(AENAME)_u.c: $(EDLFILE)
	@$(EDGER8R) --untrusted $< --search-path $(SGX_HEADER_DIR) --dump-parse ./Enclave.edl.json

$(AENAME)_u.o: $(AENAME)_u.c
	$(CXX) $(App_C_Flags) -c $< -o $@ \
	-flegacy-pass-manager \
	-Xclang -load -Xclang $(SGX_SDK)/lib64/libSGXFuzzerPass.so

$(APP_NAME): $(AENAME)_u.o
	$(CXX) $^ -o $@ $(App_Link_Flags)

.PHONY: clean
clean:
	@$(RM) *.o
	@$(RM) *.so
	@$(RM) *.map
	@$(RM) *_t.*
	@$(RM) *_u.* $(APP_NAME)
ifeq ("$(shell test -f $(EPID_SDK_DIR)/Makefile && echo Makefile exists)", "Makefile exists")
	-$(MAKE) -C $(EPID_SDK_DIR) clean
endif
	@$(RM) -r $(EPID_SDK_DIR)/Makefile $(EPID_SDK_DIR)/config.log $(EPID_SDK_DIR)/config.status

.PHONY: rebuild
rebuild:
	$(MAKE) clean
	$(MAKE) all

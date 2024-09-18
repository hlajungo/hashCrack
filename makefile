CXX = g++
CXXFLAGS = -Wall -O2

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

SRC_FILES = $(wildcard $(SRC_DIR)/*.cpp)
OBJ_FILES = $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC_FILES))

TARGET = $(BIN_DIR)/dictFliter.bin

all: $(TARGET)

$(TARGET): $(OBJ_FILES)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# 方便的目標來查看文件結構
print:
	@echo "Source files: $(SRC_FILES)"
	@echo "Object files: $(OBJ_FILES)"
	@echo "Target binary: $(TARGET)"

# 禁止 make 使用內建規則
.SUFFIXES:

# 禁止目標與文件名稱相同
.PHONY: all clean print


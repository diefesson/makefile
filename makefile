info:
	-@echo 'makefile simples criado por Diefesson de Sousa Silva(diefesson.so@gmail.com)'
	-@echo 'produzido com intuito educacional de prover um makefile simples e legivel'
	-@echo 'que possa ser usado no desenvolvimento de pequenos projetos e '
	-@echo 'auxiliar desenvolvedores que estão aprendedo a usar a ferramenta make'
	-@echo 'versao de 05/03/20'
	-@echo 'inspirado na estrutura de arquivos de administradores de projeto Java(ex. Maven)'
	-@echo 'para preparar o projeto execute "make setup"'
	-@echo 'para outros comandos veja os comentarios nesse arquivo'
	-@echo 'OBS: ainda nao testei os comandos de teste desse makefile'

#raízes
ROOT=src
TEST_ROOT=test
BACKUP_ROOT=backup

#pastas principais
C_FOLDER=$(ROOT)/src
H_FOLDER=$(ROOT)/inc
O_FOLDER=$(ROOT)/obj
OUT_FOLDER=$(ROOT)/out

#pastas de teste
TEST_C_FOLDER=$(TEST_ROOT)/src
TEST_H_FOLDER=$(TEST_ROOT)/inc
TEST_O_FOLDER=$(TEST_ROOT)/obj
TEST_OUT_FOLDER=$(TEST_ROOT)/out

#arquivos principais
SRC_FILES=$(wildcard $(C_FOLDER)/*.cpp)
H_FILES=$(wildcard $(H_FOLDER)/*.hpp)
O_FILES=$(subst $(C_FOLDER),$(O_FOLDER),$(subst .cpp,.o,$(SRC_FILES)))
OUT_FILE=$(OUT_FOLDER)/programa

#arquivos de teste
TEST_SRC_FILES=$(wildcard $(TEST_C_FOLDER)/*.cpp)
TEST_H_FILES=$(wildcard $(TEST_H_FOLDER)/*.hpp)
TEST_O_FILES=$(subst $(TEST_C_FOLDER),$(TEST_O_FOLDER),$(subst .cpp,.o,$(TEST_SRC_FILES)))
TEST_OUT_FILES=$(subst $(TEST_C_FOLDER),$(TEST_OUT_FOLDER),$(subst .cpp,,$(TEST_SRC_FILES)))

#compilar e versão do C
CC=g++
STD=c++17

#flags de inclusão de baçalho
INCLUDE_FLAGS=-I./$(H_FOLDER)
TEST_INCLUDE_FLAGS=-I./$(TEST_H_FOLDER)

#flags de compilação
COMPILER_FLAGS=-Wall -std=$(STD) $(INCLUDE_FLAGS)
TEST_COMPILER_FLAGS=$(COMPILER_FLAGS) $(TEST_INCLUDE_FLAGS) #além do headers padrão podem ser incluindos headers de teste
LINKER_FLAGS=-std=$(STD)
TEST_LINKER_FLAGS=-std=$(STD)

#COMANDOS
#compila e roda os testes
test:$(TEST_OUT_FILES)

#compila o projeto
compile:$(OUT_FILE)

#executa o projeto, se necessario compila automaticamente
run:compile
	./$(OUT_FILE)

#limpa o projeto, util em caso de erros estranhos
clean:
	rm -rf ./$(O_FOLDER)/* ./$(TEST_O_FOLDER)/*
	rm -rf ./$(OUT_FOLDER)/* ./$(TEST_OUT_FOLDER)/*

#prepara o projeto
setup:
	-mkdir ./$(ROOT) ./$(TEST_ROOT) #cria pastas raizes
	-mkdir ./$(BACKUP_ROOT) ./$(BACKUP_ROOT)/src ./$(BACKUP_ROOT)/test #cria pastas de backup
	-mkdir ./$(C_FOLDER) ./$(H_FOLDER) ./$(O_FOLDER) ./$(OUT_FOLDER) #cria pastas do projeto
	-mkdir ./$(TEST_C_FOLDER) ./$(TEST_H_FOLDER) ./$(TEST_O_FOLDER) ./$(TEST_OUT_FOLDER) #cria pastas de testes

#deleta o projeto, mas mantém backup
delete:
	-rm -rf ./$(ROOT) ./$(TEST_ROOT)

#deleta e prepara o projeto
reset:delete setup

#realiza o backup do projeto
backup:delete_backup
	-cp -r ./$(ROOT)/* ./$(BACKUP_ROOT)/src
	-cp -r ./$(TEST_ROOT)/* ./$(BACKUP_ROOT)/test

#recupera o backup do projeto
recover:setup
	-cp -r ./$(BACKUP_ROOT)/src/* ./$(ROOT)
	-cp -r ./$(BACKUP_ROOT)/test/* ./$(TEST_ROOT)

#deleta o backup
delete_backup:
	-rm -rf ./$(BACKUP_ROOT)/src/* ./$(BACKUP_ROOT)/test/*

#gera arquivo de saída
$(OUT_FILE):$(O_FILES)
	$(CC) $(LINKER_FLAGS) -o $@ $^

#gera objetos
$(O_FOLDER)/%.o:$(C_FOLDER)/%.cpp
	$(CC) $(COMPILER_FLAGS) -c -o $@ $<

#gera arquivo de teste e executa o teste
$(TEST_OUT_FOLDER)/%:$(TEST_O_FOLDER)/%.o
	$(CC) $(TEST_LINKER_FLAGS) -o $@ $<
	-./$@

#gera objetos de teste
$(TEST_O_FOLDER)/%.o:$(TEST_C_FOLDER)/%.cpp
	$(CC) $(TEST_COMPILER_FLAGS) -c -o $@ $<
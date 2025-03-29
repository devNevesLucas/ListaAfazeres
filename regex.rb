require 'date'

class ListaAfazeres
    def initialize()
        @tags = []
        @horario = ""
        @pessoas = []
        @data = ""
        @acao = ""
        @url = ""
        @email = ""
    end

    def tags
        @tags
    end
    
    def reconhecerTags(cadeia)
        resultado = cadeia.scan(/#\w+/).flatten
        @tags = resultado

        if @tags.length > 0
            puts "Tags: " + @tags.join(", ")
        end
    end    

    def reconhecerHorario(cadeia)
        resultado = cadeia.scan(/(((a|à)s ?)(((((0?\d)|(1\d)|(2[0-4]))(:| ))\d{1,2}( |(?!.)))|((0?\d(?!.))|(1\d)|(2[0-4])))(hora(s?))?)/).flatten

        if resultado.length == 0
            resultado = cadeia.scan(/(((a|à)s ?)?(((((0\d)|(1\d)|(2[0-4]))(:| ))\d{1,2})|((0\d)|(1\d)|(2[0-4])))( hora(s?)))/).flatten
        end
        if resultado.length == 0
            resultado = cadeia.scan(/(((a|à)s ?)?(((((0\d)|(1\d)|(2[0-4]))(:| ))\d{1,2})|((0\d)(^\d)|(1\d)(^\d)|(2[0-4])(^\d)))( hora(s?))?)/).flatten
        end

        @horario = resultado.first 

        if @horario == nil
            return
        end

        puts "Horario: " + @horario
    end

    def reconhecerAcoes(cadeia)

        resultado = cadeia.match /(?<acao>\w+(r|ão)) (com( ((o?)|(a?))? ?)?|para( (o? )|(a? ))? ?)[A-Z]\w+(( e ?| |, ?)[A-Z]\w+)*/        

        @acao = resultado[:acao]

        pessoas = resultado.to_s.sub(/(\w+(r|ão)) (com( ((o?)|(a?))? ?)?|para( (o? )|(a? ))? ?)/, '')

        pessoasList = pessoas.split(/\s*,\s*|\s+e\s+/)
        @pessoas = pessoasList

        puts "Ação: " + @acao
        puts "Pessoas: " + @pessoas.join(", ")
    end

    def reconhecerDatas(cadeia) 
        
        resultado = cadeia.match /(hoje)|((depois de )?amanh(a|ã))/

        if resultado == nil || resultado.length == 0            
            resultado = cadeia.match(/([0-3]?\d)(\/((0\d)|(1[0-2])))(\/\d{2,4})?/)
        end
        
        if resultado == nil || resultado.length == 0
            resultado = cadeia.match /(([^a-zA-Z\s])[0-3]?\d) (de ?)?[^\d\W]+( (de ?)?(\d\d)?\d\d)? /
        end

        if resultado == nil || resultado.length == 0
            return
        end

        resultadoString = resultado.to_s
        flagData = false

        if resultadoString.include?("hoje")         
            @data = Date.today
            flagData = true
        end    

        if !flagData && (resultadoString.include?("depois de"))
            @data = Date.today + 2
            flagData = true
        end

        if !flagData && (resultadoString.include?("amanha") || resultadoString.include?("amanhã"))
            @data = Date.today + 1
            flagData = true
        end
        
        if !flagData
            @data = resultadoString
        end

        if @data.kind_of?(String)
            puts "Data: " + @data

        else
            puts "Data: " + @data.strftime("%d/%m/%y")
        end

    end

    def reconhecerEmails(cadeia)
        resultado = cadeia.match /(?<!\S)(([^\.\@](\w|\-|\.|\_|){1,62}[^\.])@((\w+\.){1,254})(\w+))/

        @email = resultado.to_s

        if @email != ""
            puts "Email: " + @email
        end

    end

    def reconhecerAfazeres(cadeia)
        
        puts "\nEntrada : " + cadeia + "\n\n"
        puts "Resultado: \n\n"

        reconhecerTags(cadeia)
        reconhecerHorario(cadeia)
        reconhecerAcoes(cadeia)
        reconhecerDatas(cadeia)
        reconhecerEmails(cadeia)

        puts "\n"
    end


end    

lista = ListaAfazeres.new()

lista.reconhecerAfazeres("Enviar para o Celso o EP2 de LFA até dia 31/03/2025 #Senac #LFA")
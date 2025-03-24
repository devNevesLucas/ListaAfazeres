class ListaAfazeres
    def initialize()
        @tags = []
        @horario = ""
        @pessoas = []
        @acao = ""
        @url = ""
    end

    def tags
        @tags
    end
    
    def reconhecerTags(cadeia)
        resultado = cadeia.scan(/#\w+/).flatten
        @tags = resultado
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
    end

    def reconhecerAcoes(cadeia)

        resultado = cadeia.match /(?<acao>\w+(r|ão)) (com( ((o?)|(a?))? ?)?|para( (o?)|(a?))?)[A-Z]\w+(( e ?| |, ?)[A-Z]\w+)*/

        puts resultado[:acao]
    end

    def reconhecerDatas(cadeia) 
        
        resultado = cadeia.match /(hoje)|((depois de )?amanh(a|ã))/

        if resultado.length == 0
            resultado = cadeia.match /[0-3]?\d (de ?)?[^\d\W]+( (de ?)?(\d\d)?\d\d)? /
        end

        if resultado.length == 0
            resultao = cadeia.match /([0-3]?\d)(\/((0\d)|(1[0-2])))(\/\d{2,4})?/
        end

        puts resultado.to_s
    end

    def reconhecerEmails(cadeia)
        resultado = cadeia.match /(?<!\S)(([^\.\@](\w|\-|\.|\_|){1,62}[^\.])@((\w+\.){1,254})(\w+))/

        puts resultado.to_s
    end

    def reconhecerAfazeres(cadeia)
        
        reconhecerTags(cadeia)
        reconhecerHorario(cadeia)
        reconhecerAcoes(cadeia)
        reconhecerDatas(cadeia)
        reconhecerEmails(cadeia)
    end


end    

lista = ListaAfazeres.new()

lista.reconhecerAfazeres("Agendar com Jose, Henrique, Bruno e Antonio reunião #aiaiaiuiui amanhã às 10:00 #trabalho #escola email: testeDeTeste.a@email.com.br")

puts lista.tags
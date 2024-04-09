require 'json'

def contar_palavras(arquivo)
  frequencias = Hash.new(0)
  texto = File.read(arquivo)
  palavras = texto.scan(/\b\w+\b/)
  palavras.each { |palavra| frequencias[palavra.downcase] += 1 unless palavra.match?(/^\d+$/) } # ignora palavras que contem apenas numeros
  frequencias
end

def salvar_resultados(resultados, nome_arquivo)
  File.open(nome_arquivo, 'w') do |file|
    file.puts(JSON.pretty_generate(resultados))
  end
end

def processar_arquivos(diretorio)
  resultados = Hash.new(0)

  Dir.glob("#{diretorio}/*.srt") do |arquivo|
    episodio = File.basename(arquivo, ".*") # extrai o nome do episodio do nome do arquivo
    frequencias_arquivo = contar_palavras(arquivo)
    resultados[episodio] = frequencias_arquivo.sort_by { |palavra, frequencia| -frequencia }
  end

  resultados
end

# diretorio onde os arquivos .srt estão localizados
diretorio_arquivos = "arquivos"

# Verifica se o diretorio de resultados existe se não, ele cria
diretorio_resultados = "resultados"
Dir.mkdir(diretorio_resultados) unless Dir.exist?(diretorio_resultados)

# Processa os arquivos e salva os results
resultados_por_episodio = processar_arquivos(diretorio_arquivos)
resultados_por_episodio.each do |episodio, frequencias|
  salvar_resultados(frequencias, "#{diretorio_resultados}/episodio-#{episodio}.json")
end

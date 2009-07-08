namespace :alcoholic do
  desc "This task will purchase your Vodka"
  task :purchaseAlcohol do
    puts "Purchased Vodka"
  end

  desc "This task will mix a good cocktail"
  task :mixDrink => :purchaseAlcohol do
    puts "Mixed Fuzzy Navel"
  end

  desc "This task will drink one too many"
  task :getSmashed => :mixDrink do
    puts "Dood, everthing's blurry, can I halff noth'r drinnnk?"
  end

  desc "Presenta la lista de departametos"
  task :departamento => :environment do
    Departamento.find(:all).each do |v|
      puts "Depto: %10s, abrev: %5s" % [v.nombre, v.abreviacion]
    end
  end

  desc "Presenta todos los task dentro de Alcoholic"
  task :todos => [:getSmashed, :departamento]

end
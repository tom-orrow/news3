require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke

    User.create!([
      { id: 1,
        email: 'admin@example.com',
        password: 'password',
        role: 'admin',
        fullname: 'Admin',
        confirmed_at: '2013-09-18 15:12:55' },
      { id: 2,
        email: 'someone@example.com',
        password: 'password',
        fullname: 'John Doe',
        confirmed_at: '2013-09-18 15:12:55' }
    ])

    Category.create!([
      { id: 1, name: 'News' },
        { id: 2, name: 'Reports', parent_id: 1 },
        { id: 3, name: 'Culture', parent_id: 1 },
        { id: 4, name: 'Recent', parent_id: 1 },
      { id: 5, name: 'Reviews' },
        { id: 6, name: 'Recent', parent_id: 5 },
        { id: 7, name: 'Nintendo', parent_id: 5 },
        { id: 8, name: 'Playstation', parent_id: 5 },
        { id: 9, name: 'Xbox', parent_id: 5 },
        { id: 10, name: 'Mobile', parent_id: 5 },
        { id: 11, name: 'PC', parent_id: 5 },
      { id: 12, name: 'Features' },
        { id: 13, name: 'This Week', parent_id: 12 },
        { id: 14, name: 'Last Week', parent_id: 12},
        { id: 15, name: 'Human Angle', parent_id: 12 },
      { id: 16, name: 'Videos' },
        { id: 17, name: 'Recent', parent_id: 16 },
        { id: 18, name: 'Overview', parent_id: 16 },
        { id: 19, name: 'Human Angle', parent_id: 16 },
      { id: 20, name: 'Platforms' },
        { id: 21, name: 'Nintendo', parent_id: 20 },
          { id: 22, name: 'Wii U', parent_id: 21 },
          { id: 23, name: 'Wii', parent_id: 21 },
          { id: 24, name: '3DS', parent_id: 21 },
        { id: 25, name: 'Playstation', parent_id: 20 },
          { id: 26, name: 'Playstation 4', parent_id: 25 },
          { id: 27, name: 'Playstation 3', parent_id: 25 },
          { id: 28, name: 'Playstation Vita', parent_id: 25 },
        { id: 29, name: 'Xbox', parent_id: 20 },
          { id: 30, name: 'Xbox One', parent_id: 29 },
          { id: 31, name: 'Xbox 360', parent_id: 29 },
        { id: 32, name: 'Mobile', parent_id: 20 },
          { id: 33, name: 'iOS', parent_id: 32 },
          { id: 34, name: 'Android', parent_id: 32 },
        { id: 35, name: 'PC', parent_id: 20 },
          { id: 36, name: 'Windows', parent_id: 35 },
          { id: 37, name: 'Mac', parent_id: 35 },
          { id: 38, name: 'Linux', parent_id: 35 },
    ])

    50.times do |n|
      Article.create!([
        title: 'When a successful game is a failure',
        description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor ' +
          'incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, ' +
          'quis nostrud exercitation ullamco laboris',
        body: 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium,
          totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta
          sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia
          consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est,
          qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora
          incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum
          exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?
          Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur,
          vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
          Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium,
          totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta
          sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia
          consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est,
          qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora
          incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum
          exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?
          Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur,
          vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
          Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium,
          totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta
          sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia
          consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est,
          qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora
          incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum
          exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?
          Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur,
          vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
          Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium,
          totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta
          sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia
          consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est,
          qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora
          incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum
          exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?
          Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur,
          vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?',
        active: true,
        user_id: 1,
        tag_list: 'car, cake, candle',
        category_ids: [rand(1..38), rand(1..38)],
        title_pic: File.open(Rails.root + 'public/uploads/article/title_pic/sample/' + (rand(1..9).to_s + '.jpg'))
      ])
    end
  end
end
